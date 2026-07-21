defmodule HeadsUp.Incidents do
  alias HeadsUp.Repo
  alias __MODULE__.Incident
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    # Incident
    # |> where([i], i.id == ^id)
    # |> preload(:category)
    # |> Repo.one!()

    Repo.get!(Incident, id)
    |> Repo.preload(:category)
  end

  def list_responses(%Incident{} = incident) do
    # Repo.get!(Incident, incident)
    # |> Repo.preload(:responses)

    incident
    |> Ecto.assoc(:responses)
    |> preload(:user)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def filter_incidents(filter) do
    Incident
    |> with_status(filter["status"])
    |> with_category(filter["category"])
    |> search_by(filter["q"])
    |> sort(filter["sort_by"])
    |> preload(:category)
    |> Repo.all()
  end

  defp with_status(query, status) when status in ~w(resolved pending canceled) do
    where(query, status: ^status)
  end

  defp with_status(query, _status), do: query

  def with_category(query, category_slug) when category_slug in ["", nil], do: query

  def with_category(query, category_slug) do
    # from i in query,
    #   join: c in Category,
    #   on: i.category_id == c.id,
    #   where: c.slug == ^category_slug

    # this will work if you have ecto association setup between the
    # the two tables
    from i in query,
      join: c in assoc(i, :category),
      on: i.category_id == c.id,
      where: c.slug == ^category_slug
  end

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [i], ilike(i.name, ^"%#{q}%"))
  end

  defp sort(query, "priority_desc") do
    order_by(query, desc: :priority)
  end

  defp sort(query, "priority_asc") do
    order_by(query, asc: :priority)
  end

  defp sort(query, "name") do
    order_by(query, asc: :name)
  end

  defp sort(query, "category") do
    # order_by(query, asc: :category_id)
    from i in query,
      join: c in assoc(i, :category),
      order_by: {:asc, c.name}
  end

  defp sort(query, _sort) do
    order_by(query, :id)
  end

  # def get_incident(id) when is_binary(id) do
  #   id |> String.to_integer() |> get_incident()
  # end

  def git_status_options() do
    Ecto.Enum.values(Incident, :status)
  end

  def urgent_incidents(incident) do
    Process.sleep(1000)

    Incident
    |> where(status: :pending)
    |> where([i], i.id != ^incident.id)
    |> order_by(:priority)
    |> Repo.all()
  end
end

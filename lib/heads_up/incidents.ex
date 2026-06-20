defmodule HeadsUp.Incidents do
  alias HeadsUp.Repo
  alias __MODULE__.Incident
  import Ecto.Query

  def list_incidents do
    Repo.all(Incident)
  end

  def get_incident!(id) do
    Repo.get!(Incident, id)
  end

  # def get_incident(id) when is_binary(id) do
  #   id |> String.to_integer() |> get_incident()
  # end

  def urgent_incidents(incident) do
    list_incidents() |> List.delete(incident)

    Incident
    |> where(status: :pending)
    |> where([i], i.id != ^incident.id)
    |> order_by(:priority)
    |> Repo.all()
  end
end

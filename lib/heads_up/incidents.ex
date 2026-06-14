defmodule HeadsUp.Incidents do
  alias HeadsUp.Repo
  alias __MODULE__.Incident

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
  end
end

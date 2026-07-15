defmodule HeadsUp.Admin do
  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident
  import Ecto.Query

  def list_incidents do
    Incident
    |> order_by(desc: :inserted_at)
    |> preload(:category)
    |> Repo.all()
  end

  def create_incident(attrs \\ %{}) do
    %Incident{}
    |> Incident.changeset(attrs)
    |> Repo.insert()
  end

  def get_incident(id) do
    # Incident
    # |> where(id: ^id)
    # |> Repo.one!()

    case Repo.get(Incident, id) do
      nil -> {:error, :not_found}
      incident -> {:ok, incident}
    end
  end

  def update_incident(%Incident{} = incident, attrs) do
    incident
    |> Incident.changeset(attrs)
    |> Repo.update()
  end

  def delete_incident(%Incident{} = incident) do
    Process.sleep(2000)

    incident
    |> Repo.delete()
  end

  # this function is used to validate the form for entering
  # incident data
  def change_incident(%Incident{} = incident, attrs \\ %{}) do
    incident
    |> Incident.changeset(attrs)
  end
end

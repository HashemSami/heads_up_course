defmodule HeadsUp.Admin do
  alias HeadsUp.Repo
  alias HeadsUp.Incidents.Incident
  import Ecto.Query

  def list_incidents do
    Incident
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def create_incident(attrs \\ %{}) do
    %Incident{
      name: attrs["name"],
      description: attrs["description"],
      priority: attrs["priority"],
      status: attrs["status"],
      image_path: attrs["image_path"]
      # category: animals
    }
    |> Repo.insert!()
  end
end

defmodule HeadsUpWeb.Api.IncidentJSON do
  def index(%{incidents: incidents}) do
    %{
      incidents:
        for(
          incident <- incidents,
          do: data(incident)
        )
    }
  end

  def show(%{incident: incident}) do
    data(incident)
  end

  defp data(incident) do
    %{
      id: incident.id,
      name: incident.name,
      priority: incident.priority,
      description: incident.description,
      status: incident.status,
      category_id: incident.category_id
    }
  end
end

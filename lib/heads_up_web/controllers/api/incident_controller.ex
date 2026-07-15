defmodule HeadsUpWeb.Api.IncidentController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Admin

  action_fallback HeadsUpWeb.FallbackController

  def index(conn, _params) do
    incidents = Admin.list_incidents()
    render(conn, :index, incidents: incidents)
  end

  def show(conn, %{"id" => id}) do
    with {:ok, incident} <- Admin.get_incident(id) do
      render(conn, :show, incident: incident)
    end

    # rescue
    #   Ecto.NoResultsError ->
    #     conn
    #     |> put_status(:not_found)
    #     |> put_view(json: HeadsUpWeb.ErrorJSON)
    #     |> render(:"404")
  end

  def create(conn, %{"incident" => incident_params}) do
    with {:ok, incident} <- Admin.create_incident(incident_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/incidents/#{incident}")
      |> render(:show, incident: incident)
    end
  end
end

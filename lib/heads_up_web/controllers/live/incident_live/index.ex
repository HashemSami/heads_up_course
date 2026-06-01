defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        incidents: HeadsUp.Incidents.list_incidents()
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="incident-index">
        <div class="incidents">
          <.incident_card :for={incident <- @incidents} incident={incident} />
        </div>
      </div>
    </Layouts.app>
    """
  end

  def incident_card(assigns) do
    ~H"""
    <div class="card">
      <img src={@incident.image_path} />
      <h2>{@incident.description}</h2>
      <div class="details">
        <.badge status={@incident.status} class="" />
        <div class="priority">
          {@incident.priority}
        </div>
      </div>
    </div>
    """
  end
end

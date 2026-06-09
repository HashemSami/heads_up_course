defmodule HeadsUpWeb.IncidentLive.Show do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    incident = Incidents.get_incident(id)

    socket =
      socket
      |> assign(incident: incident)
      |> assign(page_title: incident.name)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="incident-show">
        <div class="incident">
          <img src={@incident.image_path} alt="" />
          <section>
            <.badge status={@incident.status} />
            <h2>{@incident.name}</h2>
            <div class="priority">
              Priority {@incident.priority}
            </div>
            <div class="description">
              {@incident.description}
            </div>
          </section>
        </div>
      </div>
    </Layouts.app>
    """
  end
end

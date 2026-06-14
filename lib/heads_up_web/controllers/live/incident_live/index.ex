defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  import HeadsUpWeb.CustomComponents
  alias HeadsUp.Incidents
  alias HeadsUp.Incidents.Incident

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        page_title: "Incidents"
      )
      |> stream(:incidents, Incidents.list_incidents())

    socket =
      attach_hook(socket, :log_stream, :after_render, fn
        socket ->
          IO.inspect(socket)
          socket
      end)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="incident-index">
        <.head_line>
          <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
          <:tagline :let={vibe}>
            Thanks for pitching in. {vibe}
          </:tagline>
        </.head_line>

        <div class="incidents" id="incidents" phx-update="stream">
          <.incident_card
            :for={{dom_id, incident} <- @streams.incidents}
            incident={incident}
            id={dom_id}
          />
        </div>
      </div>
    </Layouts.app>
    """
  end

  attr :incident, Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident.id}"} id={@id}>
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
    </.link>
    """
  end
end

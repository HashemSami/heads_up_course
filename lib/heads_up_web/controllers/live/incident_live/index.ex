defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view

  import HeadsUpWeb.CustomComponents
  alias HeadsUp.Incidents
  alias HeadsUp.Incidents.Incident

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Incidents")

    # socket =
    #   attach_hook(socket, :log_stream, :handle_event, fn
    #     socket ->
    #       IO.inspect(socket)
    #       socket
    #   end)

    {:ok, socket}
  end

  def handle_params(unsigned_params, uri, socket) do
    # form = to_form(%{"q" => "", "status" => "", "sort_by" => ""})

    socket =
      socket
      |> assign(:page_title, "Incidents")
      |> stream(:incidents, Incidents.filter_incidents(unsigned_params))
      |> assign(:form, to_form(unsigned_params))

    {:noreply, socket}
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

        <.filter_form form={@form} />

        <div class="incidents" id="incidents" phx-update="stream">
          <div id="empty" class="no-results only:block hidden">
            No raffles found. Try changing your filters.
          </div>
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

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter" phx-submit="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="1000" />
      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={Incidents.git_status_options()}
      />
      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort By"
        options={[:priority, :name]}
        options={[
          "Priority: High to low": "priority_asc",
          "Priority: Low to high": "priority_desc",
          Name: "name"
        ]}
      />

      <.link navigate={~p"/incidents"}>
        Reset
      </.link>
    </.form>
    """
  end

  attr :incident, Incident, required: true
  attr :id, :string, required: true

  def incident_card(assigns) do
    ~H"""
    <.link navigate={~p"/incidents/#{@incident.id}"} id={@id}>
      <div class="card">
        <img src={@incident.image_path} />
        <h2>{@incident.name}</h2>
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

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_navigate(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end
end

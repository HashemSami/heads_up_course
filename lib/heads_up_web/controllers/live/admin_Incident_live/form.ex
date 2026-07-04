defmodule HeadsUpWeb.AdminIncidentLive.Form do
  alias HeadsUp.Admin
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Incident")
      |> assign(:form, to_form(%{}, as: "incident"))

    # |> stream(:incidents, Admin.list_incidents())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        New Incident
      </.header>

      <.form for={@form} id="incident-form" phx-submit="save">
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:priority]} type="number" label="Priority" />

        <.input
          field={@form[:status]}
          type="select"
          prompt="Choose the status"
          options={[:resolved, :pending, :canceled]}
        />
        <.input field={@form[:image_path]} label="Image path" />
        <.button phx-disable-with="Saving...">
          Save Incident
        </.button>
      </.form>

      <.link navigate={~p"/admin/incidents"}>
        Back
      </.link>
    </Layouts.app>
    """
  end

  def handle_event("save", %{"incident" => form_params}, socket) do
    _incident = Admin.create_incident(form_params)

    socket = push_navigate(socket, to: ~p"/admin/incidents")
    {:noreply, socket}
  end
end

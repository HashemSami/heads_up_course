defmodule HeadsUpWeb.AdminIncidentLive.Form do
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

      <.form for={@form} id="incident-form">
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
        <.button>
          Save Incident
        </.button>
      </.form>

      <.link navigate={~p"/admin/incidents"}>
        Back
      </.link>
    </Layouts.app>
    """
  end
end

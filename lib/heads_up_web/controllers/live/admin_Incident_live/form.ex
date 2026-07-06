defmodule HeadsUpWeb.AdminIncidentLive.Form do
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Admin
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    changeset = Incident.changeset(%Incident{}, %{})

    socket =
      socket
      |> assign(:page_title, "New Incident")
      |> assign(:form, to_form(changeset, as: "incident"))

    # |> stream(:incidents, Admin.list_incidents())
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        New Incident
      </.header>

      <.form for={@form} id="incident-form" phx-submit="save" phx-change="validate">
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
    case Admin.create_incident(form_params) do
      {:ok, incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident created successfully")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"incident" => form_params}, socket) do
    changeset = Incident.changeset(%Incident{}, form_params)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end
end

defmodule HeadsUpWeb.AdminIncidentLive.Form do
  alias HeadsUp.Categories
  alias HeadsUp.Incidents.Incident
  alias HeadsUp.Admin
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket, :category_options, get_category_names())

    {:ok, socket}
  end

  def handle_params(unsigned_params, _uri, socket) do
    # Delegate the socket mutation down to a multi-clause reducer function
    {:noreply, apply_action(socket, socket.assigns.live_action, unsigned_params)}
  end

  defp apply_action(socket, :new, _params) do
    incident = %Incident{}
    changeset = Admin.change_incident(incident)

    socket
    |> assign(:page_title, "New Incident")
    |> assign(:form, to_form(changeset, as: "incident"))
    |> assign(:incident, incident)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    incident = Admin.get_incident!(id)
    changeset = Admin.change_incident(incident)

    socket
    |> assign(:page_title, "Edit Incident")
    |> assign(:form, to_form(changeset, as: "incident"))
    |> assign(:incident, incident)
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
      </.header>

      <.form for={@form} id="incident-form" phx-submit="save" phx-change="validate">
        <.input field={@form[:name]} label="Name" required />
        <.input
          field={@form[:category_id]}
          label="Category"
          type="select"
          prompt="Choose the Category"
          options={@category_options}
        />

        <.input field={@form[:description]} type="textarea" label="Description" phx-debounce="blur" />
        <.input field={@form[:priority]} type="number" label="Priority" />

        <.input
          field={@form[:status]}
          label="Status"
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
    save_incident(socket, socket.assigns.live_action, form_params)
  end

  def handle_event("validate", %{"incident" => form_params}, socket) do
    changeset = Admin.change_incident(socket.assigns.incident, form_params)
    socket = assign(socket, :form, to_form(changeset, action: :validate))
    {:noreply, socket}
  end

  defp save_incident(socket, :new, incident_params) do
    case Admin.create_incident(incident_params) do
      {:ok, _incident} ->
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

  defp save_incident(socket, :edit, incident_params) do
    case Admin.update_incident(socket.assigns.incident, incident_params) do
      {:ok, _incident} ->
        socket =
          socket
          |> put_flash(:info, "Incident updated successfully")
          |> push_navigate(to: ~p"/admin/incidents")

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, socket}
    end
  end

  defp get_category_names() do
    Categories.category_names_and_ids()
  end
end

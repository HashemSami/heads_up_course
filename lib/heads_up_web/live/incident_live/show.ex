defmodule HeadsUpWeb.IncidentLive.Show do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  alias HeadsUp.Responses
  alias HeadsUp.Responses.Response
  import HeadsUpWeb.CustomComponents

  on_mount {HeadsUpWeb.UserAuth, :mount_current_scope}

  def mount(_params, _session, socket) do
    socket = add_form(socket, socket.assigns.current_scope)

    {:ok, socket}
  end

  defp add_form(socket, %{user: user} = scope) do
    changeset = Responses.change_response(scope, %Response{user_id: user.id})
    socket |> assign(:form, to_form(changeset))
  end

  defp add_form(socket, _), do: socket

  def handle_params(%{"id" => id}, _uri, socket) do
    if connected?(socket) do
      Incidents.subscribe_to_incident(id)
    end

    incident = Incidents.get_incident!(id)

    responses = Incidents.list_responses(incident)

    socket =
      socket
      |> assign(incident: incident)
      |> stream(:responses, responses)
      |> assign(:response_count, Enum.count(responses))
      |> assign(page_title: incident.name)
      # |> assign(:urgent_incidents, Incidents.urgent_incidents(incident))
      |> assign_async(:urgent_incidents, fn ->
        {:ok, %{urgent_incidents: Incidents.urgent_incidents(incident)}}
        # {:error, "out to lunch"}
      end)

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
            <header>
              <div>
                <h2>{@incident.name}</h2>
                <h3>{@incident.category.name}</h3>
              </div>
              <div class="priority">
                Priority {@incident.priority}
              </div>
            </header>
            <div class="totals">
              {@response_count} Responses
            </div>
            <div class="description">
              {@incident.description}
            </div>
          </section>
        </div>
        <div class="activity">
          <div class="left">
            <div :if={@incident.status == :pending}>
              <%= if @current_scope do %>
                <.form for={@form} id="response-form" phx-change="validate" phx-submit="save">
                  <.input
                    field={@form[:status]}
                    type="select"
                    prompt="Choose a status"
                    options={[:enroute, :arrived, :departed]}
                  />
                  <.input field={@form[:note]} type="textarea" placeholder="Note..." autofocus />
                  <button class="btn btn-primary">
                    Post
                  </button>
                </.form>
              <% else %>
                <.link href={~p"/users/log-in"} class="button">
                  Log In to Post
                </.link>
              <% end %>
            </div>
            <div id="responses" phx-update="stream">
              <.response
                :for={{dom_id, response} <- @streams.responses}
                id={dom_id}
                response={response}
              />
            </div>
          </div>
          <div class="right">
            <.urgent_incidents incidents={@urgent_incidents} />
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  def urgent_incidents(assigns) do
    ~H"""
    <section>
      <h4>Urgent Incidents</h4>
      <.async_result :let={result} assign={@incidents}>
        <:loading>
          <div class="loading">
            <div class="spinner"></div>
          </div>
        </:loading>
        <:failed :let={{:error, reason}}>
          <div class="failed">
            Async failed {reason}
          </div>
        </:failed>
        <ul class="incidents">
          <li :for={incident <- result}>
            <.link navigate={~p"/incidents/#{incident.id}"}>
              <img src={incident.image_path} alt="" /> {incident.name}
            </.link>
          </li>
        </ul>
      </.async_result>
    </section>
    """
  end

  attr :id, :string, required: true
  attr :response, Response, required: true

  def response(assigns) do
    ~H"""
    <div class="response" id={@id}>
      <span class="timeline"></span>
      <section>
        <div class="avatar">
          <.icon name="hero-user-solid" />
        </div>

        <div>
          <span class="username">
            {@response.user.username}
          </span>
          <span>
            {@response.status}
          </span>

          <blockquote>
            {@response.note}
          </blockquote>
        </div>
      </section>
    </div>
    """
  end

  def handle_event("validate", %{"response" => response_params}, socket) do
    %{current_scope: scope} = socket.assigns

    changeset =
      Responses.change_response(scope, %Response{user_id: scope.user.id}, response_params)

    socket =
      socket
      |> assign(:form, to_form(changeset, action: :validate))

    {:noreply, socket}
  end

  def handle_event("save", %{"response" => response_params}, socket) do
    %{incident: incident, current_scope: scope} = socket.assigns

    case Responses.create_response(scope, incident, response_params) do
      {:ok, _response} ->
        changeset = Responses.change_response(scope, %Response{user_id: scope.user.id})

        # response = Responses.preload_user(response)

        socket =
          socket
          |> assign(:form, to_form(changeset))

        IO.inspect(socket.assigns.streams.responses)
        {:noreply, socket}

      {:error, changeset} ->
        socket =
          assign(socket, :form, to_form(changeset, action: :validate))

        {:noreply, socket}
    end
  end

  def handle_info({:response_created, response}, socket) do
    socket =
      socket
      # at 0 will put the item on top of the stream
      |> stream_insert(:responses, response, at: 0)
      |> update(:response_count, &(&1 + 1))

    {:noreply, socket}
  end

  def handle_info({:incident_updated, incident}, socket) do
    {:noreply, assign(socket, :incident, incident)}
  end
end

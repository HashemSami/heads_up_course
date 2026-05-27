defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, responders: 0, minutes_per_responders: 10)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="effort">
        <h1>Community Love</h1>
        <section>
          <button phx-click="add" phx-value-quantity="2">+</button>
          <div>
            {@responders}
          </div>
          &times
          <div>
            {@minutes_per_responders}
          </div>
          =
          <div>
            {@responders * @minutes_per_responders}
          </div>
        </section>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    quantity = String.to_integer(quantity)
    socket = update(socket, :responders, &(&1 + 1 * quantity))
    {:noreply, socket}
  end
end

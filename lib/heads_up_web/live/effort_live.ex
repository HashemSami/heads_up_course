defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), "resp", 2000)
    end

    {:ok, assign(socket, responders: 0, minutes_per_responder: 10, page_title: "Efforts")}
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
            {@minutes_per_responder}
          </div>
          =
          <div>
            {@responders * @minutes_per_responder}
          </div>
        </section>

        <form phx-submit="set_minutes">
          <label for="minutes">Minutes Per Responder:</label>
          <input type="number" name="minutes" value={@minutes_per_responder} />
        </form>
      </div>
    </Layouts.app>
    """
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    quantity = String.to_integer(quantity)
    socket = update(socket, :responders, &(&1 + 1 * quantity))
    {:noreply, socket}
  end

  def handle_event("set_minutes", %{"minutes" => minutes}, socket) do
    socket = assign(socket, :minutes_per_responder, String.to_integer(minutes))
    {:noreply, socket}
  end

  def handle_info("resp", socket) do
    Process.send_after(self(), "resp", 2000)

    {:noreply, update(socket, :responders, &(&1 + 3))}
  end
end

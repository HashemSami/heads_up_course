defmodule HeadsUpWeb.TipsHTML do
  use HeadsUpWeb, :html

  embed_templates "tips_html/*"

  def show(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="tips">
        <h1>You Like a Tip, {@answer}?</h1>
        <p>{@tip.text}</p>
      </div>
    </Layouts.app>
    """
  end
end

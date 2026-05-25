defmodule HeadsUpWeb.TipsController do
  use HeadsUpWeb, :controller
  alias HeadsUp.Tips

  def index(conn, _params) do
    tips = Tips.list_tips()
    render(conn, :index, tips: tips)
  end

  def show(conn, params) do
    tip = Tips.get_tips(params["id"])
    render(conn, tip: tip)
  end
end

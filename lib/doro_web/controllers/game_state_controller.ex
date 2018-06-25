defmodule DoroWeb.GameStateController do
  use DoroWeb, :controller

  def edit(conn, _params) do
    render conn, "edit.html"
  end

end

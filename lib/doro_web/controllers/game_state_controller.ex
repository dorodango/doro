defmodule DoroWeb.GameStateController do
  use DoroWeb, :controller

  plug :put_layout, "react.html"

  def edit(conn, _params) do
    render conn, "edit.html"
  end
end

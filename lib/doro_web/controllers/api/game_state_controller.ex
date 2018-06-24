defmodule DoroWeb.Api.GameStateController do
  use DoroWeb, :controller

  import Inspector

  def show(conn, _params) do
    render conn, "show.json", state: %{ empty: "empty" }
  end
end

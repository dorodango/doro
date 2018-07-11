defmodule DoroWeb.Api.GameStateController do
  use DoroWeb, :controller

  def create(conn, _params) do
    Doro.World.load()
    send_resp(conn, :ok, "")
  end

  def update(conn, %{"entities" => entities}) do
    # atomize the keys all the way down
    entities
    |> Poison.encode!()
    |> Poison.decode!(keys: :atoms)
    |> Doro.World.load_debug()

    send_resp(conn, :ok, "")
  end
end

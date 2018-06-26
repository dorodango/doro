defmodule DoroWeb.Api.GameStateController do
  use DoroWeb, :controller

  def create(conn, _params) do
    Doro.World.clobber_from_default
    send_resp(conn, :ok, "")
  end

  def show(conn, _params) do
    render conn, "show.json", %{state: %{ entities:  Doro.World.GameState.get_entities}}
  end

  def update(conn, params) do
    params
    |> Poison.encode
    |> case do
         {:ok, json} ->
           json |> reload_world
           send_resp(conn, :ok, "")
         _ ->
           send_resp(
             conn,
             :internal_server_error,
             %{error: "failed to read game state.json"} |> Poison.encode!
           )
       end
  end

  defp reload_world(json), do: json |> Doro.World.clobber_from_string

end

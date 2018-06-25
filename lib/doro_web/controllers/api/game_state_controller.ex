defmodule DoroWeb.Api.GameStateController do
  use DoroWeb, :controller

  def create(conn, _params) do
    Doro.World.clobber_from_default
    send_resp(conn, :ok, "")
  end

  def show(conn, _params) do
    render conn, "show.json", %{state: read_game_state_json()}
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
  defp read_game_state_json do
    Path.join(:code.priv_dir(:doro), "game_state.json")
    |> File.read!()
    |> Poison.decode
    |> case do
         {:ok, json} -> json
         _ -> %{error: "failed to read game state.json"}
       end
  end

end

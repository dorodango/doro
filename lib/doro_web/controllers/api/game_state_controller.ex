defmodule DoroWeb.Api.GameStateController do
  use DoroWeb, :controller

  def show(conn, _params) do
    render conn, "show.json", %{state: read_game_state_json()}
  end

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

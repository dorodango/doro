defmodule DoroWeb.PlayerChannel do
  use Phoenix.Channel

  def join("player:debug", _params, socket) do
    {:ok, socket}
  end

  def handle_in("cmd", %{"cmd" => cmd, "player" => player}, socket) do
    with {:ok, ctx} <- Doro.Parser.parse(cmd, player),
         {:ok, output} <- Doro.Engine.player_input(ctx) do
      broadcast(socket, "output", %{body: output})
    else
      _ ->
        broadcast(socket, "output", %{body: "Huh?"})
    end

    {:noreply, socket}
  end
end

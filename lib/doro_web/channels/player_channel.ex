defmodule DoroWeb.PlayerChannel do
  require Logger

  use Phoenix.Channel

  def join("player:debug", _, socket) do
    Logger.info("Player '#{socket.assigns.player_id}' connected via Phoenix Channels")
    {:ok, socket}
  end

  def handle_in("cmd", %{"cmd" => "/reload"}, socket) do
    Doro.GameState.reload()
    broadcast(socket, "output", %{body: "Game state reloaded"})
    {:noreply, socket}
  end

  def handle_in("cmd", %{"cmd" => cmd}, socket) do
    with {verb, object_id} <- Doro.Parser.parse(cmd),
         {:ok, ctx} <- Doro.Context.create(socket.assigns.player_id, verb, object_id),
         {:ok, ctx} <- Doro.Engine.player_input(ctx) do
      broadcast_from(socket, "output", %{body: Enum.join(ctx.tp_responses, " ")})
      push(socket, "output", %{body: Enum.join(ctx.fp_responses, " ")})
    else
      _ ->
        push(socket, "output", %{body: "Huh?"})
    end

    {:noreply, socket}
  end
end

defmodule DoroWeb.PlayerChannel do
  use Phoenix.Channel

  def join("player:debug", _params, socket) do
    {:ok, socket}
  end

  def handle_in("cmd", %{"cmd" => cmd, "player" => player_id}, socket) do
    with {verb, object_id} <- Doro.Parser.parse(cmd),
         {:ok, ctx} <- Doro.Context.create(player_id, verb, object_id),
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

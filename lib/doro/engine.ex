defmodule Doro.Engine do
  alias Phoenix.PubSub

  def player_input(player_id, s) do
    {verb, object_id} = Doro.Parser.parse(s)
    {:ok, ctx} = Doro.Context.create(s, player_id, verb, object_id)
    Doro.Entity.execute_behaviors(ctx)
  end

  def send_to_player(player_id, s) do
    PubSub.broadcast(Doro.PubSub, "player-session:#{player_id}", {:send, s})
  end
end

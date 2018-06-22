defmodule Doro.Engine do
  import Doro.Comms

  def player_input(player_id, s) do
    {verb, object_id} = Doro.Parser.parse(s)
    {:ok, ctx} = Doro.Context.create(s, player_id, verb, object_id)
    process_command(ctx)
  end

  # reflexive (player) command
  # object is set to player in this case
  def process_command(ctx = %{object: nil, player: player}) do
    case Doro.Entity.first_responder(player, ctx) do
      nil ->
        send_to_player(player, "What you talkin bout willizzz.")

      behavior ->
        Doro.Behavior.execute(behavior, %{ctx | object: player})
    end
  end

  # transitive command
  def process_command(ctx = %{player: player}) do
    responding_behaviors =
      Doro.World.entities_in_locations(MapSet.new([player, player.props.location]))
      |> Enum.filter(&Doro.Entity.is_called?(&1, ctx.object_id))
      |> Enum.map(fn entity -> {entity, Doro.Entity.first_responder(entity, ctx)} end)
      |> Enum.filter(fn {_, behavior} -> behavior end)
      |> Apex.ap()

    case responding_behaviors do
      [] ->
        send_to_player(player, "What you talkin bout willis.")

      [{_, behavior}] ->
        # object is set to the only object in this case
        Doro.Behavior.execute(behavior, ctx)

      _ ->
        send_to_player(player, "Be more specific, plz.")
    end
  end
end

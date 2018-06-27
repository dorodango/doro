defmodule Doro.CLI do
  @moduledoc """
  Main entry point for incoming player commands.

  When a command comes in, it is parsed and then flows through like:
    1. Look for local entities (in room or inventory) named (ctx.rest).
       If there is nothing named that we implicitly use the player.
    2. Transform the entities into a list of {<entity>, <behavior>}, where <behavior> is the behavior that
       can respond to `ctx.verb` in the current context.  For example, a `Portable` item that isn't
       in the player's inventory can't be dropped, even though the `Portable` behavior responds to
       the verb `drop`.
    3. Filter out non-responding entities from the list.
    4. If there is more than one after filtering, disambiguate.
       If there is only one, execute that behavior.
       If there are zero, output an error message.
  """

  import Doro.Comms
  alias Doro.Context

  def interpret(player_id, s) do
    {verb, rest} = Doro.Parser.parse(s)

    {:ok, ctx = %{player: player, rest: object_name}} =
      Doro.Context.create(s, player_id, verb, rest)

    # echo command back to player
    send_to_player(player, "> #{s}")

    entity_behaviors =
      Doro.World.get_named_entities_in_locations(object_name, [player.id, player[:location]])
      |> Enum.map(fn entity -> {entity, Doro.Entity.first_responder(entity, ctx)} end)
      |> Enum.filter(fn {_, behavior} -> behavior end)

    case entity_behaviors do
      [] -> [{player, Doro.Entity.first_responder(player, ctx)}]
      _ -> entity_behaviors
    end
    |> execute_entity_behavior(ctx)
  end

  defp execute_entity_behavior([], %Context{player: player}) do
    send_to_player(player, "Huh?")
  end

  defp execute_entity_behavior([{_, nil}], %Context{player: player}) do
    send_to_player(player, "Huh?")
  end

  defp execute_entity_behavior([{object, behavior}], ctx) do
    Doro.Behavior.execute(behavior, %{ctx | object: object})
  end

  defp execute_entity_behavior(entity_behaviors, %Context{player: player}) do
    entities = Enum.map(entity_behaviors, &elem(&1, 0))

    send_to_player(
      player,
      "Which do you mean? #{Doro.SentenceConstruction.definite_list(entities)}?"
    )
  end
end

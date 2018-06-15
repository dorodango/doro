defmodule Doro.Engine do
  @moduledoc """
  Main loop for the application
  """

  @doc """
  Processes a string of player input.
  """
  @spec player_input(%Doro.Context{}) :: {:ok, any()}
  def player_input(ctx) do
    IO.inspect(ctx.subject, label: "Subject")
    IO.inspect(ctx.object, label: "Object")
    IO.inspect(ctx.verb, label: "Verb")

    {:ok, ctx} =
      Doro.GameState.get_entity(ctx.object)
      |> Doro.Entity.execute_behaviors(ctx)

    {:ok, Enum.join(ctx.responses, " ")}
    # "DEBUG subject: #{ctx.subject} verb: #{ctx.verb} object: #{ctx.object}"}
  end
end

defmodule Doro.Entity do
  defstruct id: nil, behaviors: [], props: %{}

  @doc "Execute the behaviors for an entity"
  @spec execute_behaviors(%Doro.Context{}) :: {:ok, %Doro.Context{}} | {:error, any()}
  def execute_behaviors(ctx) do
    Enum.reduce(ctx.object.behaviors, ctx, fn behavior, acc -> behavior.handle(acc) end)
  end
end

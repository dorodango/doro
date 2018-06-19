defmodule Doro.Entity do
  defstruct id: nil,
            behaviors: [],
            props: %{}

  def execute_behaviors(ctx) do
    Enum.reduce(ctx.object.behaviors, ctx, fn behavior, acc -> behavior.handle(acc) end)
  end
end

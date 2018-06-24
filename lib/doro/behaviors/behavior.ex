defmodule Doro.Behavior do
  defmacro __using__(_opts) do
    quote do
      def handle(ctx), do: ctx
      def responds_to?(verb, ctx), do: false

      def __behavior?(), do: :ok

      defoverridable handle: 1, responds_to?: 2
    end
  end

  def execute(behavior, ctx = %Doro.Context{}) do
    behavior.handle(ctx)
  end
end

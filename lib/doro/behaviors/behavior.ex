defmodule Doro.Behavior do
  defmacro __using__(_opts) do
    quote do
      def handle(ctx), do: ctx

      defoverridable handle: 1
    end
  end
end

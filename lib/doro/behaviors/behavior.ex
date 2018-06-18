defmodule Doro.Behavior do
  defmacro __using__(_opts) do
    quote do
      def send_to_player(ctx, s) do
        Doro.Engine.send_to_player(ctx.subject.id, s)
        %{ctx | handled: true}
      end

      def handle(ctx), do: ctx

      defoverridable handle: 1
    end
  end
end

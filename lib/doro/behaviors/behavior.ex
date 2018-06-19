defmodule Doro.Behavior do
  defmacro __using__(_opts) do
    quote do
      def send_to_player(ctx, s) when is_map(ctx) do
        send_to_player(ctx.subject.id, s)
        %{ctx | handled: true}
      end

      def send_to_player(player_id, s) when is_binary(player_id) do
        Doro.Engine.send_to_player(player_id, s)
      end

      def send_to_others(ctx = %{subject: %{props: %{location: location}}}, s) do
        Doro.GameState.players_in_location(location)
        |> Enum.filter(&(&1.id != ctx.subject.id))
        |> Enum.each(fn player ->
          Doro.Engine.send_to_player(player.id, s)
        end)

        %{ctx | handled: true}
      end

      def handle(ctx), do: ctx

      defoverridable handle: 1
    end
  end
end

defmodule Doro.Behavior do
  defmacro __using__(_opts) do
    quote do
      def handle(ctx), do: ctx
      def responds_to?(verb, ctx), do: false
      def synonyms, do: %{}

      def __behavior?(), do: :ok

      defoverridable handle: 1, responds_to?: 2, synonyms: 0
    end
  end

  def all_behaviors do
    {:ok, modules} = :application.get_key(:doro, :modules)

    modules
    |> Enum.filter(&Regex.match?(~r/^Elixir\.Doro\.Behaviors\./, Atom.to_string(&1)))
  end

  def execute(behavior, ctx = %Doro.Context{}) do
    behavior.handle(ctx)
  end
end

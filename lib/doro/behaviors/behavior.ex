defmodule Doro.Behavior do
  defmacro __using__(_opts) do
    quote do
      import Doro.Behavior

      defstruct [:props]

      @canonical_verbs []
      @synonyms %{}

      def __behavior?(), do: :ok

      @before_compile Doro.Behavior
    end
  end

  defmacro interact_if(canonical_verb, ctx, do: block) do
    quote do
      def responds_to?(unquote(canonical_verb), unquote(ctx)), do: unquote(block)
    end
  end

  defmacro interact(canonical_verb, synonyms \\ [], ctx, do: block) do
    quote do
      @canonical_verbs [unquote(canonical_verb) | @canonical_verbs]
      @synonyms Map.put(@synonyms, unquote(canonical_verb), unquote(synonyms))

      def handle(unquote(canonical_verb), unquote(ctx)), do: unquote(block)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def handle(verb, ctx), do: ctx

      def verbs(), do: @canonical_verbs
      def synonyms(), do: @synonyms

      @canonical_verbs MapSet.new(@canonical_verbs)
      def responds_to?(verb, _) do
        MapSet.member?(@canonical_verbs, verb)
      end

      @key __MODULE__
           |> Macro.underscore()
           |> String.split("/")
           |> List.last()
           |> String.to_atom()
      def key, do: @key
    end
  end

  def all_behaviors do
    {:ok, modules} = :application.get_key(:doro, :modules)

    modules
    |> Enum.filter(&Regex.match?(~r/^Elixir\.Doro\.Behaviors\./, Atom.to_string(&1)))
  end

  def execute(behavior, ctx = %Doro.Context{}) do
    behavior.handle(ctx.verb, ctx)
  end
end

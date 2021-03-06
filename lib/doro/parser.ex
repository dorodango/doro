defmodule Doro.Parser do
  use GenServer

  @moduledoc """
  Transforms user input into a structured content that can be
  then passed to the main engine.
  """

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def normalize_verb(verb) do
    GenServer.call(__MODULE__, {:normalize, verb})
  end

  @doc """
  Processes a string of user input.
  """
  @spec parse(String.t()) :: {String.t(), String.t()} | :error
  def parse(s) do
    case Regex.run(~r/^\s*([\/\w]+)\s*(.*)/, s, capture: :all_but_first) do
      [verb, ""] ->
        {normalize_verb(verb), nil}

      [verb, rest] ->
        {normalize_verb(verb), rest |> String.trim()}

      [verb] ->
        {normalize_verb(verb), nil}

      _ ->
        :error
    end
  end

  @impl true
  def init(_) do
    {:ok, %{synonyms: synonym_map()}}
  end

  @impl true
  def handle_call({:normalize, verb}, _, state = %{synonyms: synonyms}) do
    normalized =
      verb
      |> String.trim()
      |> String.downcase()

    {:reply, Map.get(synonyms, normalized, normalized), state}
  end

  def synonym_map do
    Doro.Behavior.all_behaviors()
    |> Enum.reduce(%{}, fn behavior, acc ->
      Enum.reduce(behavior.synonyms(), acc, fn {k, v}, acc2 ->
        Map.put(acc2, k, Map.get(acc2, k, []) ++ v)
      end)
    end)
    |> Enum.reduce(%{}, fn {canonical, synonyms}, acc ->
      Map.merge(
        acc,
        Enum.reduce(synonyms, %{}, fn synonym, acc2 ->
          Map.put(acc2, synonym, canonical)
        end)
      )
    end)
  end
end

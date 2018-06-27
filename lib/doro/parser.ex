defmodule Doro.Parser do
  @moduledoc """
  Transforms user input into a structured content that can be
  then passed to the main engine.
  """

  @doc """
  Processes a string of user input.
  """
  @spec parse(String.t()) :: {String.t(), String.t()} | :error
  def parse(s) do
    case Regex.run(~r/^\s*([\/\w]+)\s*(.*)/, s, capture: :all_but_first) do
      [verb, ""] ->
        {verb |> String.trim() |> String.downcase(), nil}

      [verb, rest] ->
        {verb |> String.trim() |> String.downcase(), rest |> String.trim()}

      [verb] ->
        {verb |> String.trim() |> String.downcase(), nil}

      _ ->
        :error
    end
  end
end

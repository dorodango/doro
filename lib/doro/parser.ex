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
    case String.split(s) do
      [verb, object_id] ->
        {verb, object_id}

      [verb] ->
        {verb, nil}

      _ ->
        :error
    end
  end
end

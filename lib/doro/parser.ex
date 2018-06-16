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
    with [verb, object_id] <- String.split(s) do
      {verb, object_id}
    else
      _ -> :error
    end
  end
end

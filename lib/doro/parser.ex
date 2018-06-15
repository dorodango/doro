defmodule Doro.Parser do
  @moduledoc """
  Transforms user input into a structured content that can be
  then passed to the main engine.
  """

  @doc """
  Processes a string of user input.

  ## Examples

      iex> Doro.Parser.parse("take book", "player1")
      {:ok, %{subject: "player1", object: "book", verb: "look"}}

  """
  @spec parse(String.t(), String.t()) :: {:ok, map()}
  def parse(s, user) do
    [verb, object] = String.split(s)
    {:ok, %{subject: user, verb: verb, object: object}}
  end
end

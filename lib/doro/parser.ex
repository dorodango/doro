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
  @spec parse(String.t(), String.t()) :: {:ok, %Doro.Context{}} | {:error, any()}
  def parse(s, user) do
    with [verb, object] <- String.split(s) do
      {:ok, %Doro.Context{subject: user, verb: verb, object: object}}
    else
      _ -> {:error, {:unparseable, s}}
    end
  end
end

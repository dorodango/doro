defmodule Doro.Engine do
  @moduledoc """
  Main loop for the application
  """

  @doc """
  Processes a string of player input.
  """
  @spec player_input(%Doro.Context{}) :: {:ok, any()}
  def player_input(ctx) do
    {:ok, Doro.Entity.execute_behaviors(ctx)}
  end
end

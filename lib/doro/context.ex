defmodule Doro.Context do
  alias Doro.GameState

  defstruct subject: nil,
            object: nil,
            verb: nil,
            fp_responses: [],
            tp_responses: []

  @doc "Creates a Context given some incoming request params"
  @spec create(String.t(), String.t(), String.t() | nil) :: {:ok, %Doro.Context{}}
  def create(player_id, verb, object_id) do
    {
      :ok,
      %Doro.Context{
        subject: GameState.get_entity(player_id),
        object: GameState.get_entity(object_id),
        verb: verb
      }
    }
  end

  @doc "Adds a response to be output to the player"
  @spec add_first_person_response(%Doro.Context{}, String.t()) :: %Doro.Context{}
  def add_first_person_response(ctx, response) do
    %{ctx | fp_responses: ctx.fp_responses ++ [response]}
  end

  @doc "Adds a response to be output to other players in the subject player's room"
  @spec add_third_person_response(%Doro.Context{}, String.t()) :: %Doro.Context{}
  def add_third_person_response(ctx, response) do
    %{ctx | tp_responses: ctx.tp_responses ++ [response]}
  end
end

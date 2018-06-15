defmodule Doro.Entity do
  defstruct id: nil, behaviors: [], props: %{}

  @doc "Execute the behaviors for an entity"
  @spec execute_behaviors(%Doro.Entity{}, %Doro.Context{}) ::
          {:ok, %Doro.Context{}} | {:error, any()}
  def execute_behaviors(_, ctx) do
    {:ok,
     %{
       ctx
       | responses: [
           "You #{ctx.verb} da #{ctx.object}." | ctx.responses
         ]
     }}
  end
end

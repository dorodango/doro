defmodule Doro.Behaviors.Visible do
  alias Doro.Context

  def handle(ctx = %{verb: "look"}) do
    ctx
    |> Context.add_first_person_response(ctx.object.props.description)
    |> Context.add_third_person_response(
      ~s(#{ctx.subject.id} regards #{ctx.object.id} thoughtfully.)
    )
  end

  def handle(ctx), do: ctx
end

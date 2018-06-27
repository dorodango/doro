defmodule DoroWeb.Api.GameStateView do
  use DoroWeb, :view

  def render("show.json", %{entities: entities}), do: %{entities: entities}

end

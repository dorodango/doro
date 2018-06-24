defmodule DoroWeb.Api.GameStateView do
  use DoroWeb, :view

  def render("show.json", %{state: state}), do: %{state: state}

end

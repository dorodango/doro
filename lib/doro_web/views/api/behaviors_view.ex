defmodule DoroWeb.Api.BehaviorsView do
  use DoroWeb, :view

  def render("index.json", %{behaviors: behaviors}), do: %{behaviors: behaviors}

end

defmodule DoroWeb.Api.BehaviorsController do
  use DoroWeb, :controller

  def index(conn, _params) do
    {:ok, modules} = :application.get_key(:doro, :modules)

    behaviors =
    modules
    |> Enum.reduce([], fn module, acc ->
      Code.ensure_loaded(module)

      case Keyword.get(module.__info__(:functions), :__behavior?) do
        nil -> acc
        0 -> [module |> Modules.to_underscore() | acc]
      end
    end)

    conn
    |> json(%{behaviors: behaviors})
  end
end

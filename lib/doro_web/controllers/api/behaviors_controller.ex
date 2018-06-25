defmodule DoroWeb.Api.BehaviorsController do
  use DoroWeb, :controller

  import Inspector

  def index(conn, _params) do
    { :ok, modules } = :application.get_key(:doro, :modules)
    behaviors = modules
    |> Enum.reduce([], fn module, acc ->
      Code.ensure_loaded(module)
      case Keyword.get(module.__info__(:functions), :__behavior?) do
        nil -> acc
        0 -> [ module |> to_underscore | acc]
      end
    end)

    render conn, "index.json", %{ behaviors: behaviors }
  end

  defp to_underscore(module) do
    module |> Module.split |> Enum.at(-1) |> Macro.underscore
  end
end

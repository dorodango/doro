defmodule Modules do
  @doc "return the module suffix name, underscored"
  def to_underscore(module) do
    module |> Module.split |> Enum.at(-1) |> Macro.underscore
  end

  @doc "return the module suffix name, underscored, given a module string"
  def name_to_underscore(module) do
    module |> String.split(".") |> Enum.at(-1) |> Macro.underscore
  end
end
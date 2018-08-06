defmodule Mix.Tasks.Yarn.Test do
  use Mix.Task

  @shortdoc "Runs `yarn test`"

  def run(_args) do
    Mix.shell.cmd("cd assets && yarn test")
    |> case do
         0 ->
           Mix.shell.info("[yarn test] success")
         other ->
           Mix.shell.error("[yarn test] failed")
           exit(other)
       end
  end

end

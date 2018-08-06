defmodule Mix.Tasks.Brunch.Build do
  use Mix.Task

  @shortdoc "Runs `yarn brunch build`"

  def run(_args) do
    Mix.shell.cmd("cd assets && yarn install && yarn brunch build")
    |> case do
         0 ->
           Mix.shell.info("[brunch build] success")
         other ->
           Mix.shell.error("[brunch build] failed")
           exit(other)
       end
  end

end

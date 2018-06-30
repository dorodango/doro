ExUnit.start(exclude: [:integration])

Ecto.Adapters.SQL.Sandbox.mode(Doro.Repo, :manual)

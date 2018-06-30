defmodule Inspector do
  def inspector(v, s),
    do:
      (
        IO.puts("[#{s}] #{inspect(v)}")
        v
      )

  def inspector(v),
    do:
      (
        IO.puts("[check] #{inspect(v)}")
        v
      )
end

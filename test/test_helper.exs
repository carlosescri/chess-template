defmodule Chess.TestHelper do
  def null_dashboard() do
    for _ <- 0..7 do
      Enum.map(0..7, fn _ -> nil end)
    end
  end
end

ExUnit.start()

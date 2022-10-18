defmodule Chess.Games.Game do

  def create_join_code() do
    <<:rand.uniform(1_048_576)::40>>
    |> Base.encode32()
    |> binary_part(4, 4)
  end
end
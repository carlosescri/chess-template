defmodule Chess.GameState do

  defstruct [
    name: "",
    status: :waiting,
    winner: nil,
  ]

end

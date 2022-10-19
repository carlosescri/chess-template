defmodule Chess.Square do
  alias Chess.ChessPiece

  @types %{
    id: :integer,
    chesspiece_id: :integer,
    white: :boolean,
    coordinates: {}
  }

  defstruct id: nil,
            chesspiece_id: nil,
            white: nil,
            coordinates: nil
end

defmodule Chess.ChessPiece do
  @types %{
    id: :integer,
    white: :boolean,
    type: :string
  }

  defstruct id: nil,
            white: true,
            type: nil
end

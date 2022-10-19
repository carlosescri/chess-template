defmodule Chess.Board do
  @rows [1, 2, 3, 4, 5, 6, 7, 8]
  @columns [1, 2, 3, 4, 5, 6, 7, 8]

  @position %{
    {1, 1} => {:white, :rook},
    {2, 1} => {:white, :knight},
    {3, 1} => {:white, :bishop},
    {4, 1} => {:white, :queen},
    {5, 1} => {:white, :king},
    {6, 1} => {:white, :bishop},
    {7, 1} => {:white, :knight},
    {8, 1} => {:white, :rook},
    {1, 2} => {:white, :pawn},
    {2, 2} => {:white, :pawn},
    {3, 2} => {:white, :pawn},
    {4, 2} => {:white, :pawn},
    {5, 2} => {:white, :pawn},
    {6, 2} => {:white, :pawn},
    {7, 2} => {:white, :pawn},
    {8, 2} => {:white, :pawn},
    {1, 8} => {:black, :rook},
    {2, 8} => {:black, :knight},
    {3, 8} => {:black, :bishop},
    {4, 8} => {:black, :queen},
    {5, 8} => {:black, :king},
    {6, 8} => {:black, :bishop},
    {7, 8} => {:black, :knight},
    {8, 8} => {:black, :rook},
    {1, 7} => {:black, :pawn},
    {2, 7} => {:black, :pawn},
    {3, 7} => {:black, :pawn},
    {4, 7} => {:black, :pawn},
    {5, 7} => {:black, :pawn},
    {6, 7} => {:black, :pawn},
    {7, 7} => {:black, :pawn},
    {8, 7} => {:black, :pawn}
  }

  def get_positions, do: @position

  def move(board, from, to) do
    with true <- valid_position?(from),
         true <- valid_position?(to),
         true <- movement_allowed?(board, from, to) do
      move_piece(board, from, to)
    else
      _ -> board
    end
  end

  defp get_position(board, {column, row}), do: Map.get(board, {column, row})

  defp move_piece(board, from, to) do
    piece = get_position(board, from)

    board
    |> Map.delete(from)
    |> Map.put(to, piece)
  end

  defp valid_position?({column, row}) do
    Enum.member?(@rows, row) && Enum.member?(@columns, column)
  end

  defp movement_allowed?(board, from, to) do
    !free_square?(board, from) && (free_square?(board, to) || not same_color?(board, from, to))
  end

  defp free_square?(board, {column, row}) do
    is_nil(get_position(board, {column, row}))
  end

  defp same_color?(board, square1, square2) do
    {color1, _} = get_position(board, square1)
    {color2, _} = get_position(board, square2)

    color1 == color2
  end
end

defmodule Chess.Table.Game do
  def start() do
    pieces = Chess.Table.Pieces.fresh_start()
    pieces
  end

  def move(pieces, color, from, to) do
    check_from_position = Chess.Table.Board.is_there_an_own_piece?(pieces, from, color)

    cond do
      check_from_position -> can_move(pieces, color, from, to)
      true -> :fail
    end
  end

  defp can_move(pieces, color, from, to) do
    [piece | _] = Enum.filter(pieces, fn p -> p.position == from end)
    :fail

    possible_moves =
      cond do
        piece.name == :pawn -> Chess.Table.Pawn.all_possible_moves(pieces, from, color)
        piece.name == :rook -> Chess.Table.Rook.all_possible_moves(pieces, from, color)
      end

    status =
    if(Enum.member?(possible_moves, to)) do
      :ok
    else
      :fail
    end

    pieces = Enum.drop_while(pieces, fn p -> p.position == from end)

    %{status: status, pieces: pieces ++ [%Chess.Table.Piece{name: piece.name, position: to, color: piece.color, alive: true}]}
  end
end

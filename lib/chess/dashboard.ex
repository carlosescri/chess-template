defmodule Chess.Dashboard do
  @moduledoc false

  alias Chess.Piece

  def new do
    default_board()
  end

  def default_board() do
    [
      [
        piece_b(:rook),
        piece_b(:knight),
        piece_b(:bishop),
        piece_b(:queen),
        piece_b(:king),
        piece_b(:bishop),
        piece_b(:knight),
        piece_b(:rook)
      ],
      [
        piece_b(:pawn),
        piece_b(:pawn),
        piece_b(:pawn),
        piece_b(:pawn),
        piece_b(:pawn),
        piece_b(:pawn),
        piece_b(:pawn),
        piece_b(:pawn)
      ],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [
        piece_w(:pawn),
        piece_w(:pawn),
        piece_w(:pawn),
        piece_w(:pawn),
        piece_w(:pawn),
        piece_w(:pawn),
        piece_w(:pawn),
        piece_w(:pawn)
      ],
      [
        piece_w(:rook),
        piece_w(:knight),
        piece_w(:bishop),
        piece_w(:queen),
        piece_w(:king),
        piece_w(:bishop),
        piece_w(:knight),
        piece_w(:rook)
      ]
    ]
  end

  defp piece_w(type) do
    Piece.new(type, :white)
  end

  defp piece_b(type) do
    Piece.new(type, :black)
  end

  def get(board, {pos_x, pos_y}) do
    board |> Enum.at(pos_x) |> Enum.at(pos_y)
  end

  def move(board, piece, new_pos, current_pos) do
    board
    |> put(piece, new_pos)
    |> put(nil, current_pos)
  end

  @doc """
  Put a new piece in given position
  Warning: doesn't consider any old position for removing the piece, for that use move/4
  """
  def put(board, piece_or_nil, {pos_x, pos_y}) do
    new_col =
      board
      |> Enum.at(pos_x)
      |> List.replace_at(pos_y, piece_or_nil)

    List.replace_at(board, pos_x, new_col)
  end

  def get_player_pieces(board, player) do
    board
    |> Enum.with_index()
    |> Enum.flat_map(fn {column, pos_x} ->
      column
      |> Enum.with_index()
      |> Enum.map(fn {piece, pos_y} -> {piece, {pos_x, pos_y}} end)
    end)
    |> Enum.filter(fn
      {%{color: ^player}, position} -> true
      _ -> false
    end)
  end

  def get_king_pos(board, player) do
    board
    |> Enum.with_index()
    |> Enum.reduce_while(nil, fn {column, pos_x}, _acc ->
      case lookup_king_in_column(column, player) do
        {:halt, pos_y} -> {:halt, {pos_x, pos_y}}
        _ -> {:cont, nil}
      end
    end)
  end

  def lookup_king_in_column(column, player) do
    column
    |> Enum.with_index()
    |> Enum.reduce_while(nil, fn
      {%{color: ^player, type: :king}, pos_y}, _acc -> {:halt, {:halt, pos_y}}
      _, acc -> {:cont, acc}
    end)
  end
end

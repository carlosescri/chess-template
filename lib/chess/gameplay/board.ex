defmodule Chess.Gameplay.Board do
  @moduledoc """
  Chess Play Board
  """

  alias Chess.Gameplay.Bishop
  alias Chess.Gameplay.King
  alias Chess.Gameplay.Knight
  alias Chess.Gameplay.Pawn
  alias Chess.Gameplay.Position
  alias Chess.Gameplay.Queen
  alias Chess.Gameplay.Rook

  def initial_state do
    s = %{
      {0, 0} => make_piece(:rook, :white),
      {1, 0} => make_piece(:knight, :white),
      {2, 0} => make_piece(:bishop, :white),
      {3, 0} => make_piece(:queen, :white),
      {4, 0} => make_piece(:king, :white),
      {5, 0} => make_piece(:bishop, :white),
      {6, 0} => make_piece(:knight, :white),
      {7, 0} => make_piece(:rook, :white),
      {0, 7} => make_piece(:rook, :white),
      {1, 7} => make_piece(:knight, :white),
      {2, 7} => make_piece(:bishop, :white),
      {3, 7} => make_piece(:queen, :white),
      {4, 7} => make_piece(:king, :white),
      {5, 7} => make_piece(:bishop, :white),
      {6, 7} => make_piece(:knight, :white),
      {7, 7} => make_piece(:rook, :white)
    }

    s = Enum.reduce(0..7, s, fn i, acc -> Map.put(acc, {i, 1}, make_piece(:pawn, :white)) end)
    Enum.reduce(0..7, s, fn i, acc -> Map.put(acc, {i, 6}, make_piece(:pawn, :black)) end)
  end

  def moves(board, pos, previous_moves \\ []) do
    %{type: type} = piece(board, pos)

    case type do
      :bishop ->
        Bishop.moves(board, pos)
      :king ->
        King.moves(board, pos, previous_moves)
      :knight ->
        Knight.moves(board, pos)
      :pawn ->
        Pawn.moves(board, pos, previous_moves)
      :queen ->
        Queen.moves(board, pos)
      :rook ->
        Rook.moves(board, pos)
    end
  end

  def find(board, %{type: type, colour: colour}) do
    board
    |> Enum.filter(fn {_, piece} -> match?(%{type: ^type, colour: ^colour}, piece) end)
  end

  def is_king_checked?(board, colour) do
    board
    |> find(%{type: :king, colour: colour})
    |> List.first()
    |> (fn {p, _} -> p end).()
    |> is_attacked?(board)
  end

  def is_attacked?(pos, board) do
    board
    |> Enum.any?(fn
      {^pos, _} -> false

      {p, _} -> moves(board, p) |> Enum.any?(&(pos == &1))
    end)
  end

  def move(board, start_pos, end_pos) do
    {piece, board} = Map.pop(board, start_pos)
    {captured, board} = Map.pop(board, end_pos)

    board = Map.put(board, end_pos, piece)

    board =
      cond do
        is_castle?(piece, start_pos, end_pos) ->
          board |> castle_rook(end_pos) |> Map.get(:board)

        should_promote_pawn?(piece, end_pos) ->
          promote_pawn(board, piece, end_pos)

        true ->
          board
      end

    %{
      start_p: start_pos,
      end_p: end_pos,
      board: board,
      piece: piece,
      captured: captured
    }
  end

  def piece(board, pos) do
    board[pos]
  end

  def should_promote_pawn?(%{type: :pawn, colour: :white}, {_, 7}), do: true
  def should_promote_pawn?(%{type: :pawn, colour: :black}, {_, 0}), do: true
  def should_promote_pawn?(_, _), do: false

  def promote_pawn(board, %{type: :pawn, colour: colour}, pos) do
    Map.put(board, pos, %{type: :queen, colour: colour})
  end

  def is_castle?(%{type: :king}, {4, _}, {end_c, _}), do: end_c == 6 or end_c == 2
  def is_castle?(_, _, _), do: false

  def castle_rook(board, {c, r}) when c == 2, do: board |> move({0, r}, {3, r})
  def castle_rook(board, {c, r}) when c == 6, do: board |> move({7, r}, {5, r})

  def generate_moves(board, {c, r}, move_rule) do
    colour = piece(board, {c, r}).colour
    generate_moves(board, colour, {c, r}, move_rule)
  end

  ###########
  # PRIVATE #
  ###########

  defp generate_moves(board, colour, {c, r}, {dc, dr}) do
    pos = {c + dc, r + dr}

    cond do
      !Position.is_valid?(pos) || taken(board, colour, pos) ->
        []

      can_capture?(board, colour, pos) ->
        [pos]

      true ->
        [pos | generate_moves(board, colour, pos, {dc, dr})]
    end
  end

  defp generate_moves(_board, _colour, _pos, []), do: []

  defp generate_moves(board, colour, pos, [{c, r} | moves]) do
    cond do
      !Position.is_valid?({c, r}) || taken(board, colour, {c, r}) ->
        generate_moves(board, colour, pos, moves)

      can_capture?(board, colour, {c, r}) ->
        [{c, r} | generate_moves(board, colour, pos, moves)]

      true ->
        [{c, r} | generate_moves(board, colour, pos, moves)]
    end
  end

  defp can_capture?(board, :white, {c, r}) do
    piece = board[{c, r}]
    piece && piece.colour == :black
  end

  defp can_capture?(board, :black, {c, r}) do
    piece = board[{c, r}]
    piece && piece.colour == :white
  end

  defp taken(board, colour, {c, r}) do
    piece = piece(board, {c, r})
    piece && piece.colour == colour
  end

  defp make_piece(type, colour) do
    %{type: type, colour: colour}
  end
end

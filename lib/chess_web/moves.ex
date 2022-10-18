defmodule ChessWeb.Moves do
  @letters ["A", "B", "C", "D", "E", "F", "G", "H"]
  @numbers ["1", "2", "3", "4", "5", "6", "7", "8"]

  def binary2tuple(position) do
    position
    |> String.split("")
    |> Enum.reject(&(&1 == ""))
    |> List.to_tuple()
  end

  def allowed_moves(piece, current_position) when is_binary(current_position) do
    allowed_moves(piece, binary2tuple(current_position))
  end

  def allowed_moves("rook", {letter, number}) do
    horizontal_moves = Enum.map(@letters, fn letter -> tuple2str(letter, number) end)
    vertical_moves = Enum.map(@numbers, fn number -> tuple2str(letter, number) end)

    (horizontal_moves ++ vertical_moves)
    |> Enum.reject(&(&1 == tuple2str(letter, number)))
    |> Enum.sort()
  end

  def allowed_moves("bishop", {letter, number} = position) do
    top_right_moves = top_right_diagonal([], position)
    bottom_right_moves = bottom_right_diagonal([], position)
    bottom_left_moves = bottom_left_diagonal([], position)
    top_left_moves = top_left_diagonal([], position)

    (top_right_moves ++ bottom_right_moves ++ bottom_left_moves ++ top_left_moves)
    |> Enum.reject(&(&1 == tuple2str(letter, number)))
    |> Enum.sort()
  end

  def allowed_moves("knight", {letter, number}) do
    top_right_moves = top_right_diagonal([], {letter, number})
    bottom_right_moves = []
    bottom_left_moves = []
    top_left_moves = []
    []
  end

  def allowed_moves("queen", position) do
    (allowed_moves("rook", position) ++ allowed_moves("bishop", position))
    |> Enum.dedup()
    |> Enum.sort()
  end

  def top_right_diagonal(moves, position) when is_binary(position) do
    top_right_diagonal(moves, binary2tuple(position))
  end

  def top_right_diagonal(moves, {"H", number}), do: Enum.sort([tuple2str("H", number) | moves])
  def top_right_diagonal(moves, {letter, "8"}), do: Enum.sort([tuple2str(letter, "8") | moves])

  def top_right_diagonal(moves, {letter, number}) do
    moves = [tuple2str(letter, number) | moves]
    top_right_diagonal(moves, {increment_letter(letter), increment_number(number)})
  end

  def bottom_right_diagonal(moves, position) when is_binary(position) do
    bottom_right_diagonal(moves, binary2tuple(position))
  end

  def bottom_right_diagonal(moves, {"H", number}), do: Enum.sort([tuple2str("H", number) | moves])
  def bottom_right_diagonal(moves, {letter, "1"}), do: Enum.sort([tuple2str(letter, "1") | moves])

  def bottom_right_diagonal(moves, {letter, number}) do
    moves = [tuple2str(letter, number) | moves]
    bottom_right_diagonal(moves, {increment_letter(letter), deduct_number(number)})
  end

  def bottom_left_diagonal(moves, position) when is_binary(position) do
    bottom_left_diagonal(moves, binary2tuple(position))
  end

  def bottom_left_diagonal(moves, {"A", number}), do: Enum.sort([tuple2str("A", number) | moves])
  def bottom_left_diagonal(moves, {letter, "1"}), do: Enum.sort([tuple2str(letter, "1") | moves])

  def bottom_left_diagonal(moves, {letter, number}) do
    moves = [tuple2str(letter, number) | moves]
    bottom_left_diagonal(moves, {deduct_letter(letter), deduct_number(number)})
  end

  def top_left_diagonal(moves, position) when is_binary(position) do
    top_left_diagonal(moves, binary2tuple(position))
  end

  def top_left_diagonal(moves, {"A", number}), do: Enum.sort([tuple2str("A", number) | moves])
  def top_left_diagonal(moves, {letter, "8"}), do: Enum.sort([tuple2str(letter, "8") | moves])

  def top_left_diagonal(moves, {letter, number}) do
    moves = [tuple2str(letter, number) | moves]
    top_left_diagonal(moves, {deduct_letter(letter), increment_number(number)})
  end

  def increment_letter("A"), do: "B"
  def increment_letter("B"), do: "C"
  def increment_letter("C"), do: "D"
  def increment_letter("D"), do: "E"
  def increment_letter("E"), do: "F"
  def increment_letter("F"), do: "G"
  def increment_letter("G"), do: "H"

  def deduct_letter("H"), do: "G"
  def deduct_letter("G"), do: "F"
  def deduct_letter("F"), do: "E"
  def deduct_letter("E"), do: "D"
  def deduct_letter("D"), do: "C"
  def deduct_letter("C"), do: "B"
  def deduct_letter("B"), do: "A"

  def increment_number("1"), do: "2"
  def increment_number("2"), do: "3"
  def increment_number("3"), do: "4"
  def increment_number("4"), do: "5"
  def increment_number("5"), do: "6"
  def increment_number("6"), do: "7"
  def increment_number("7"), do: "8"

  def deduct_number("8"), do: "7"
  def deduct_number("7"), do: "6"
  def deduct_number("6"), do: "5"
  def deduct_number("5"), do: "4"
  def deduct_number("4"), do: "3"
  def deduct_number("3"), do: "2"
  def deduct_number("2"), do: "1"

  def tuple2str(letter, number), do: "#{letter}#{number}"
end

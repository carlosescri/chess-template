defmodule ChessWeb.Board do
  alias ChessWeb.Moves

  def get_square_info(board, square) do
    Map.get(board, square, "")
  end

  def highlight_square(board, square) do
    unless empty_square?(board, square) do
      {_, updated} =
        Map.get_and_update(board, square, fn value -> {value, value <> " highlighted"} end)

      updated
    else
      board
    end
  end

  def remove_highlight_from_square(board, square) do
    {_, updated} =
      Map.get_and_update(board, square, fn value ->
        {value, String.replace(value, "highlighted", "")}
      end)

    updated
  end

  def move_piece(board, from, to) do
    value = Map.get(board, from)
    piece = parse_piece(value)
    allowed_moves = Moves.allowed_moves(piece, from)
    board
  end

  def empty_square?(board, square) do
    Map.get(board, square, "") == ""
  end

  def starting_board() do
    %{
      "A1" => "figure white rook",
      "A2" => "figure white pawn",
      "A3" => "",
      "A4" => "",
      "A5" => "",
      "A6" => "",
      "A7" => "figure black pawn",
      "A8" => "figure black rook",
      "B1" => "figure white knight",
      "B2" => "figure white pawn",
      "B3" => "",
      "B4" => "",
      "B5" => "",
      "B6" => "",
      "B7" => "figure black pawn",
      "B8" => "figure black knight",
      "C1" => "figure white bishop",
      "C2" => "figure white pawn",
      "C3" => "",
      "C4" => "",
      "C5" => "",
      "C6" => "",
      "C7" => "figure black pawn",
      "C8" => "figure black bishop",
      "D1" => "figure white queen",
      "D2" => "figure white pawn",
      "D3" => "",
      "D4" => "",
      "D5" => "",
      "D6" => "",
      "D7" => "figure black pawn",
      "D8" => "figure black queen",
      "E1" => "figure white king",
      "E2" => "figure white pawn",
      "E3" => "",
      "E4" => "",
      "E5" => "",
      "E6" => "",
      "E7" => "figure black pawn",
      "E8" => "figure black king",
      "F1" => "figure white bishop",
      "F2" => "figure white pawn",
      "F3" => "",
      "F4" => "",
      "F5" => "",
      "F6" => "",
      "F7" => "figure black pawn",
      "F8" => "figure black bishop",
      "G1" => "figure white knight",
      "G2" => "figure white pawn",
      "G3" => "",
      "G4" => "",
      "G5" => "",
      "G6" => "",
      "G7" => "figure black pawn",
      "G8" => "figure black knight",
      "H1" => "figure white rook",
      "H2" => "figure white pawn",
      "H3" => "",
      "H4" => "",
      "H5" => "",
      "H6" => "",
      "H7" => "figure black pawn",
      "H8" => "figure black rook"
    }
  end

  defp parse_piece(value) do
    to_reject = ["figure", "black", "white", "highlighted"]

    String.split(value, " ")
    |> Enum.reject(&Enum.member?(to_reject, &1))
    |> Enum.uniq()
    |> List.first("")
  end
end

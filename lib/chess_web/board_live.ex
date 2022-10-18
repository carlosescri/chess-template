defmodule ChessWeb.BoardLive do
  use ChessWeb, :live_component

  def update(assigns, socket) do
  {:ok,
  socket
  |> assign(assigns)
  |> assign_initial_position()}
  end

  defp assign_initial_position(socket) do
    initial_position = %{
      "A1" => {false, "r"},
      "A2" => {false, "kn"},
      "A3" => {false, "b"},
      "A4" => {false, "q"},
      "A5" => {false, "k"},
      "A6" => {false, "b"},
      "A7" => {false, "kn"},
      "A8" => {false, "r"},
      "B1" => {false, "p"},
      "B2" => {false, "p"},
      "B3" => {false, "p"},
      "B4" => {false, "p"},
      "B5" => {false, "p"},
      "B6" => {false, "p"},
      "B7" => {false, "p"},
      "B8" => {false, "p"},
      "H1" => {true, "r"},
      "H2" => {true, "kn"},
      "H3" => {true, "b"},
      "H4" => {true, "q"},
      "H5" => {true, "k"},
      "H6" => {true, "b"},
      "H7" => {true, "kn"},
      "H8" => {true, "r"},
      "G1" => {true, "p"},
      "G2" => {true, "p"},
      "G3" => {true, "p"},
      "G4" => {true, "p"},
      "G5" => {true, "p"},
      "G6" => {true, "p"},
      "G7" => {true, "p"},
      "G8" => {true, "p"},
    }
    assign(socket, :pieces, initial_position)
  end

  defp get_square_color(x, y) do
    if rem(y, 2) == 0 do
      if rem(x, 2) == 0 do
        "black"
      else
        "white"
      end
    else
      if rem(x, 2) == 0 do
        "white"
      else
        "black"
      end
    end
  end

  defp is_piece(x, y, pieces) do
    letter = x_y_into_chess_square(x, y)
    piece = Map.get(pieces, letter)
    piece_into_class(piece)

  end

  defp x_y_into_chess_square(x, y) do
    letter = List.to_string([64 + y])
    "#{letter}#{x}"
  end

  defp piece_into_class(nil), do: nil
  defp piece_into_class({is_black, type}) do
    "#{black_into_class(is_black)} #{type_into_class(type)}"
  end

  defp black_into_class(true), do: "black"
  defp black_into_class(false), do: "white"

  defp type_into_class("k"), do: "king"
  defp type_into_class("q"), do: "queen"
  defp type_into_class("r"), do: "rook"
  defp type_into_class("b"), do: "bishop"
  defp type_into_class("kn"), do: "knight"
  defp type_into_class("p"), do: "pawn"
end

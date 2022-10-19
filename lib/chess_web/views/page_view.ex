defmodule ChessWeb.PageView do
  use ChessWeb, :view

  defp get_cell_color(x, y), do: if(rem(x + y, 2) == 0, do: "white", else: "black")

  defp get_cell_piece(nil), do: ""
  defp get_cell_piece(piece), do: "figure #{piece.type} #{piece.color}"

  defp is_cell_selected(_piece, nil), do: ""
  defp is_cell_selected(piece, piece), do: "selected"
  defp is_cell_selected(_, _), do: ""

  defp is_king_removed?(color, game) do
    game
    |> get_in([Access.key(color), :removed_pieces])
    |> Enum.find(fn %{type: type} -> type == :king end) != nil
  end
end

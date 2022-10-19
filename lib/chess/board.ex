defmodule Chess.Board do
  alias Chess.Figure, as: ChessFigure

  @board_limits [1, 2, 3, 4, 5, 6, 7, 8]

  def init_board() do
    %{
      {1, 1} => ChessFigure.create(:castle, :white),
      {2, 1} => ChessFigure.create(:knight, :white),
      {3, 1} => ChessFigure.create(:bishop, :white),
      {4, 1} => ChessFigure.create(:queen, :white),
      {5, 1} => ChessFigure.create(:king, :white),
      {6, 1} => ChessFigure.create(:bishop, :white),
      {7, 1} => ChessFigure.create(:knight, :white),
      {8, 1} => ChessFigure.create(:castle, :white),
      {1, 2} => ChessFigure.create(:pawn, :white),
      {2, 2} => ChessFigure.create(:pawn, :white),
      {3, 2} => ChessFigure.create(:pawn, :white),
      {4, 2} => ChessFigure.create(:pawn, :white),
      {5, 2} => ChessFigure.create(:pawn, :white),
      {6, 2} => ChessFigure.create(:pawn, :white),
      {7, 2} => ChessFigure.create(:pawn, :white),
      {8, 2} => ChessFigure.create(:pawn, :white),
      {1, 8} => ChessFigure.create(:castle, :black),
      {2, 8} => ChessFigure.create(:knight, :black),
      {3, 8} => ChessFigure.create(:bishop, :black),
      {4, 8} => ChessFigure.create(:queen, :black),
      {5, 8} => ChessFigure.create(:king, :black),
      {6, 8} => ChessFigure.create(:bishop, :black),
      {7, 8} => ChessFigure.create(:knight, :black),
      {8, 8} => ChessFigure.create(:castle, :black),
      {1, 7} => ChessFigure.create(:pawn, :black),
      {2, 7} => ChessFigure.create(:pawn, :black),
      {3, 7} => ChessFigure.create(:pawn, :black),
      {4, 7} => ChessFigure.create(:pawn, :black),
      {5, 7} => ChessFigure.create(:pawn, :black),
      {6, 7} => ChessFigure.create(:pawn, :black),
      {7, 7} => ChessFigure.create(:pawn, :black),
      {8, 7} => ChessFigure.create(:pawn, :black)
    }
  end

  def is_valid_position?({coord_x, coord_y})
      when coord_x in @board_limits and coord_y in @board_limits,
      do: true

  def is_valid_position?({_coord_x, _coord_y}), do: false

  def get_figure_in_coords(game_positions, {coord_x, coord_y}) do
    Map.get(game_positions, {coord_x, coord_y}, nil)
  end

  def update_position(game_positions, old_coords, new_coords) do
    case get_figure_in_coords(game_positions, old_coords) do
      nil ->
        {:error, "cannot update a figure that doesen't exist"}

      figure ->
        {_, game_position_erased} = Map.pop(game_positions, old_coords)
        {:ok, Map.put(game_position_erased, new_coords, figure)}
    end
  end
end

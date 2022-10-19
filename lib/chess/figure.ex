defmodule Chess.Figure do
  alias Chess.Board, as: ChessBoard

  @available_colors [:black, :white]
  @available_figures [:castle, :knight, :bishop, :queen, :king, :pawn]

  def create(figure_type, color)
      when figure_type in @available_figures and color in @available_colors,
      do: %{
        :figure => figure_type,
        :color => color,
        :figure_css_class => "#{Atom.to_string(figure_type)} #{Atom.to_string(color)}"
      }

  def create(_figure_type, _color), do: nil

  def move(game_positions, current_figure_coords, figure_type, movement_coords, color) do
    case relative_valid_positions_from_coords(
           game_positions,
           figure_type,
           current_figure_coords,
           color
         ) do
      [] ->
        false

      movement_posibilites ->
        if movement_coords in movement_posibilites do
          {:ok, updated_game_positions} =
            ChessBoard.update_position(game_positions, current_figure_coords, movement_coords)

          updated_game_positions
        else
          false
        end
    end
  end

  def relative_valid_positions_from_coords(
        game_positions,
        _figure_type,
        {coord_x, coord_y} = current_position,
        color
      ) do
    move_posibilites = [
      {coord_x + 1, coord_y + 1},
      {coord_x + 1, coord_y},
      {coord_x, coord_y + 1},
      {coord_x - 1, coord_y + 1},
      {coord_x, coord_y - 1},
      {coord_x + 1, coord_y - 1},
      {coord_x - 1, coord_y},
      {coord_x - 1, coord_y - 1}
    ]

    Enum.reject(move_posibilites, fn move_possibility ->
      case ChessBoard.is_valid_position?(move_possibility) do
        true ->
          is_blocked_for_move?(game_positions, current_position, move_possibility, color)

        _ ->
          true
      end
    end)
  end

  def is_blocked_for_move?(
        game_positions,
        {from_coord_x, from_coord_y} = from_coords,
        {to_coord_x, to_coord_y} = destination_coords,
        color
      ) do
    case ChessBoard.get_figure_in_coords(game_positions, destination_coords) do
      nil ->
        false

      figure ->
        if figure.color == color do
          true
        else
          false
        end
    end
  end
end

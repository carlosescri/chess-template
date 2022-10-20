defmodule Chess.Movements do
  @moduledoc """
  The Movements context.
  """

  @type type_piece :: :pawn | :rook | :knight | :bishop | :king | :queen

  # @spec check_movement_by_type(type_piece(), diff_x, diff_y) :: :error | :ok
  @spec check_movement_by_type(type_piece(), any, any) :: :error | :ok

  # PAWN
  def check_movement_by_type(:pawn, 0, 2), do: :ok
  def check_movement_by_type(:pawn, 0, 1), do: :ok
  def check_movement_by_type(:pawn, 1, 1), do: :ok
  def check_movement_by_type(:pawn, _diff_x, _diff_y), do: :error

  # ROCK
  def check_movement_by_type(:rock, 0, diff_y) when diff_y > 0, do: :ok
  def check_movement_by_type(:rock, _, _), do: :error

  # BISHOP
  def check_movement_by_type(:bishop, diff_x, diff_y) when diff_y == diff_x and diff_y > 0,
    do: :ok

  def check_movement_by_type(:bishop, _diff_x, _diff_y), do: :error

  # KING
  def check_movement_by_type(:king, -1, 1), do: :ok
  def check_movement_by_type(:king, 0, 1), do: :ok
  def check_movement_by_type(:king, 1, 1), do: :ok
  def check_movement_by_type(:king, -1, 0), do: :ok
  def check_movement_by_type(:king, 1, 0), do: :ok
  def check_movement_by_type(:king, -1, -1), do: :ok
  def check_movement_by_type(:king, 0, -1), do: :ok
  def check_movement_by_type(:king, 1, -1), do: :ok
  def check_movement_by_type(:king, _diff_x, _diff_y), do: :error

  # ROCK
  def check_movement_by_type(:knight, 2, 1), do: :ok
  def check_movement_by_type(:knight, -2, 1), do: :ok
  def check_movement_by_type(:knight, 2, -1), do: :ok
  def check_movement_by_type(:knight, -2, -1), do: :ok
  def check_movement_by_type(:knight, _diff_x, _diff_y), do: :error

  # QUEEN
  def check_movement_by_type(:queen, diff_x, diff_y) when diff_y == diff_x and diff_y > 0, do: :ok
  def check_movement_by_type(:queen, diff_x, 0) when diff_x != 0, do: :ok
  def check_movement_by_type(:queen, 0, diff_y) when diff_y != 0, do: :ok
  def check_movement_by_type(:queen, _diff_x, _diff_y), do: :error
end

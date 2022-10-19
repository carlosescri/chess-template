defmodule Chess.Board do
  @moduledoc """
  This module represents the board and it will store every data and action related to the squares and their limitations
  """

  alias Chess.Piece

  @max_square_position 7
  @min_square_position 0

  defguard inside_of_board(x, y) when x <= @max_square_position and y <= @max_square_position and x >= @min_square_position and y >= @min_square_position

  def initial_board(), do: %{
    {0, 0} => %{colour: :black, piece: :rook},
    {0, 1} => %{colour: :black, piece: :knight},
    {0, 2} => %{colour: :black, piece: :bishop},
    {0, 3} => %{colour: :black, piece: :queen},
    {0, 4} => %{colour: :black, piece: :king},
    {0, 5} => %{colour: :black, piece: :bishop},
    {0, 6} => %{colour: :black, piece: :knight},
    {0, 7} => %{colour: :black, piece: :rook},
    {1, 0} => %{colour: :black, piece: :pawn},
    {1, 1} => %{colour: :black, piece: :pawn},
    {1, 2} => %{colour: :black, piece: :pawn},
    {1, 3} => %{colour: :black, piece: :pawn},
    {1, 4} => %{colour: :black, piece: :pawn},
    {1, 5} => %{colour: :black, piece: :pawn},
    {1, 6} => %{colour: :black, piece: :pawn},
    {1, 7} => %{colour: :black, piece: :pawn},
    {6, 0} => %{colour: :white, piece: :pawn},
    {6, 1} => %{colour: :white, piece: :pawn},
    {6, 2} => %{colour: :white, piece: :pawn},
    {6, 3} => %{colour: :white, piece: :pawn},
    {6, 4} => %{colour: :white, piece: :pawn},
    {6, 5} => %{colour: :white, piece: :pawn},
    {6, 6} => %{colour: :white, piece: :pawn},
    {6, 7} => %{colour: :white, piece: :pawn},
    {7, 0} => %{colour: :white, piece: :rook},
    {7, 1} => %{colour: :white, piece: :knight},
    {7, 2} => %{colour: :white, piece: :bishop},
    {7, 3} => %{colour: :white, piece: :queen},
    {7, 4} => %{colour: :white, piece: :king},
    {7, 5} => %{colour: :white, piece: :bishop},
    {7, 6} => %{colour: :white, piece: :knight},
    {7, 7} => %{colour: :white, piece: :rook},
  }

  def move(current_position, current_position, state), do: state
  def move(_current_position,
    {goto_x, goto_y},
    state
    ) when not inside_of_board(goto_x, goto_y), do: state

  def move(current_position, goto_position, state) do
    current_square = Map.get(state, current_position)
    goto_square = Map.get(state, goto_position)
    
    if possible_action?(state, current_position, goto_position, current_square, goto_square) do
      state
      |> Map.get(current_position)
      |> (&Map.put(state, goto_position, &1)).()
      |> Map.delete(current_position)
    else
      state
    end
  end
  
  defp possible_action?(_, _, _, %{colour: colour}, %{colour: colour}), do: false

  defp possible_action?(state, current_position, goto_position, %{colour: colour, piece: piece}, nil),
    do: Piece.possible_move?(state, current_position, goto_position, colour, piece)
  defp possible_action?(state, current_position, goto_position, %{colour: colour, piece: piece}, _),
    do: Piece.possible_attack?(state, current_position, goto_position, colour, piece)

end

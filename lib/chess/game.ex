defmodule Chess.Game do
  alias Chess.Game.State
  alias Chess.Game.Piece

  def new() do
    %State{
      white: [
        %Piece{type: :king, position: {3, 0}},
        %Piece{type: :queen, position: {4, 0}},
        %Piece{type: :bishop, position: {2, 0}},
        %Piece{type: :bishop, position: {5, 0}},
        %Piece{type: :knight, position: {1, 0}},
        %Piece{type: :knight, position: {6, 0}},
        %Piece{type: :rook, position: {0, 0}},
        %Piece{type: :rook, position: {7, 0}},
        %Piece{type: :pawn, position: {0, 1}},
        %Piece{type: :pawn, position: {1, 1}},
        %Piece{type: :pawn, position: {2, 1}},
        %Piece{type: :pawn, position: {3, 1}},
        %Piece{type: :pawn, position: {4, 1}},
        %Piece{type: :pawn, position: {5, 1}},
        %Piece{type: :pawn, position: {6, 1}},
        %Piece{type: :pawn, position: {7, 1}}
      ],
      black: [
        %Piece{type: :king, position: {3, 7}},
        %Piece{type: :queen, position: {4, 7}},
        %Piece{type: :bishop, position: {2, 7}},
        %Piece{type: :bishop, position: {5, 7}},
        %Piece{type: :knight, position: {1, 7}},
        %Piece{type: :knight, position: {6, 7}},
        %Piece{type: :rook, position: {0, 7}},
        %Piece{type: :rook, position: {7, 7}},
        %Piece{type: :pawn, position: {0, 6}},
        %Piece{type: :pawn, position: {1, 6}},
        %Piece{type: :pawn, position: {2, 6}},
        %Piece{type: :pawn, position: {3, 6}},
        %Piece{type: :pawn, position: {4, 6}},
        %Piece{type: :pawn, position: {5, 6}},
        %Piece{type: :pawn, position: {6, 6}},
        %Piece{type: :pawn, position: {7, 6}}
      ]
    }
  end

  def get_all_pieces(%State{white: white_pieces, black: black_pieces}),
    do: white_pieces ++ black_pieces

  def find_piece(position, [piece | rest]) do
    if piece.position == position do
      piece
    else
      find_piece(position, rest)
    end
  end

  def find_piece(_position, []), do: nil

  def move(state, movement, player) do
    if legal_move?(state, movement, player) do
      apply_movement(state, movement, player)
    else
      {:error, "illegal movement"}
    end
  end

  defp apply_movement(state, {piece, {x, y}}, player) do
    player_updated_pieces =
      state
      |> Map.get(player)
      |> Enum.map(&if(&1 == piece, do: %{piece | position: {x, y}}, else: &1))

    eaten_piece = find_piece({x, y}, Map.get(state, opponent(player)))

    opponent_updated_pieces =
      state
      |> Map.get(opponent(player))
      |> Enum.reject(&(&1 == eaten_piece))

    state =
      state
      |> Map.put(player, player_updated_pieces)
      |> Map.put(opponent(player), opponent_updated_pieces)
      |> Map.put(:turn, opponent(player))

    if Map.get(eaten_piece || %{}, :type) == :king do
      {:king_died, Map.put(state, :turn, nil)}
    else
      {:ok, state}
    end
  end

  defp legal_move?(state, {piece, {x, y}}, _player) do
    not out_of_table?(x, y) and Piece.legal_move?({x, y}, piece) and
      State.legal_move?({x, y}, piece.position, state)
  end

  defp out_of_table?(x, y), do: x < 0 or x > 7 or y < 0 or y > 7

  defp opponent(:white), do: :black
  defp opponent(:black), do: :white
end

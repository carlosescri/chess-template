defmodule Chess.Gameplay.Game do
  @moduledoc """
  Initiate game process and moves
  """

  alias Chess.Gameplay.Board


  def initial(), do: %{turn: :white, board: Board.initial_state(), moves: [], captured_pieces: []}

  def move(game_state, from_pos, to_pos) do
    %{board: board, turn: turn} = game_state

    case Board.piece(board, from_pos) do
      nil -> {:error, "No piece at position"}
      %{colour: ^turn} -> exec_move(game_state, from_pos, to_pos)
      _ -> {:error, "Not your turn"}
    end
  end

  ###########
  # PRIVATE #
  ###########

  defp exec_move(game_state, from_pos, to_pos) do
    with {:ok, _} <- game_state |> valid_move?(from_pos, to_pos) do
      {
        :ok,
        game_state
        |> Map.get(:board)
        |> Board.move(from_pos, to_pos)
        |> update_game_state(game_state)
      }
    else
      {:error, message} -> {:error, message}
    end
  end

  defp update_game_state(
         %{board: board, captured: captured, piece: piece, start_p: start_p, end_p: end_p},
         game_state
       ) do
    %{
      board: board,
      moves:
        (game_state
         |> Map.get(:moves)) ++
        [%{start_p: start_p, end_p: end_p, piece: piece}],
      turn: game_state |> Map.get(:turn) |> flip_turn(),
      captured_pieces: game_state |> Map.get(:captured_pieces) |> append_if_not_nil(captured)
    }
  end

  defp append_if_not_nil(list, nil), do: list
  defp append_if_not_nil(list, el), do: list ++ [el]

  defp flip_turn(:white), do: :black
  defp flip_turn(:black), do: :white

  defp valid_move?(%{board: board, turn: turn, moves: prev_moves}, from_p, to_p) do
    cond do
      board |> Board.moves(from_p, prev_moves) |> Enum.any?(&(&1 == to_p)) |> negate ->
        {:error, "It's not available move for selected piece"}

      board |> Board.move(from_p, to_p) |> Map.get(:board) |> Board.is_king_checked?(turn) ->
        {:error, "The king would be in check"}

      true ->
        {:ok, nil}
    end
  end

  defp negate(b), do: !b
end

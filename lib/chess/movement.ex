defmodule Chess.Movement do
  @moduledoc false

  alias Chess.Dashboard

  @king_posibilities [
    {1, 1},
    {1, -1},
    {-1, 1},
    {-1, -1},
    {1, 0},
    {-1, 0},
    {0, 1},
    {0, -1}
  ]
  @horse_posibilities [{1, 2}, {1, -2}, {-1, 2}, {-1, -2}, {2, 1}, {-2, 1}, {2, -1}, {-2, -1}]

  require Logger

  def possible_movements(board, {pos_x, pos_y} = position)
      when pos_x < 8 and pos_y < 8 and pos_x >= 0 and pos_y >= 0 do
    piece = Dashboard.get(board, position)
    Logger.debug("pos: #{inspect(position)}, piece: #{inspect(piece)}")

    movements(piece, board, position)
  end

  def movements(piece, board, position, verify_check \\ true)

  def movements(nil, _, position, _verify_check) do
    raise "no piece to move in pos #{inspect(position)}"
  end

  def movements(%{type: :pawn, color: player} = piece, board, piece_pos, verify_check) do
    board
    |> get_pawn_moves(piece_pos, player)
    |> check_verify_and_move_filter(board, piece, piece_pos, verify_check)
  end

  def movements(%{type: :rook, color: player} = piece, board, piece_pos, verify_check) do
    board
    |> get_line_moves(piece_pos, player)
    |> check_verify_and_move_filter(board, piece, piece_pos, verify_check)
  end

  def movements(%{type: :bishop, color: player} = piece, board, piece_pos, verify_check) do
    board
    |> get_diagonal_moves(piece_pos, player)
    |> check_verify_and_move_filter(board, piece, piece_pos, verify_check)
  end

  def movements(%{type: :knight, color: player} = piece, board, piece_pos, verify_check) do
    board
    |> get_knight_moves(piece_pos, player)
    |> check_verify_and_move_filter(board, piece, piece_pos, verify_check)
  end

  def movements(%{type: :queen, color: player} = piece, board, piece_pos, verify_check) do
    moves =
      get_line_moves(board, piece_pos, player) ++ get_diagonal_moves(board, piece_pos, player)

    check_verify_and_move_filter(moves, board, piece, piece_pos, verify_check)
  end

  def movements(%{type: :king, color: player} = piece, board, piece_pos, verify_check) do
    board
    |> get_king_moves(piece_pos, player)
    |> check_verify_and_move_filter(board, piece, piece_pos, verify_check)
  end

  def get_pawn_moves(board, {pos_x, pos_y}, player) do
    increment = if player == :white, do: -1, else: 1
    normal_move = {pos_x + increment, pos_y}
    possible_eats = [{pos_x + increment, pos_y + 1}, {pos_x + increment, pos_y - 1}]

    response = get_moves_unless_blocked(board, normal_move, player)

    response =
      if (player == :white and pos_x == 6) or (player == :black and pos_x == 1) do
        # possible extra move when starting
        possible_move = {pos_x + increment * 2, pos_y}

        get_moves_unless_blocked(board, possible_move, player) ++ response
      else
        response
      end

    possible_eats
    |> Enum.filter(fn position ->
      movement_action(board, position, player) == :eat
    end)
    |> Enum.concat(response)
    |> Enum.sort()
  end

  @doc """
  Check in given board, if player is in check (his king is being threatened)
  """
  def in_check?(board, player) do
    king_pos = Dashboard.get_king_pos(board, player)
    king_can_die?(board, king_pos, player)
  end

  def checkmate?(board, player) do
    player_in_check? = in_check?(board, player)
    player_can_move? = can_move?(board, player)
    move_without_check? = any_move_without_check?(board, player)

    cond do
      player_in_check? and not move_without_check? ->
        true

      not player_in_check? and not player_can_move? ->
        :drowned

      true ->
        false
    end
  end

  defp get_king_moves(board, my_pos, player) do
    get_movements_by_posibilities(board, my_pos, player, @king_posibilities)
  end

  defp get_knight_moves(board, my_pos, player) do
    get_movements_by_posibilities(board, my_pos, player, @horse_posibilities)
  end

  defp get_movements_by_posibilities(board, {pos_x, pos_y}, player, posibilities) do
    posibilities
    |> Enum.map(fn {x, y} -> {pos_x + x, pos_y + y} end)
    |> Enum.reject(&invalid_position?/1)
    |> Enum.filter(fn position ->
      case movement_action(board, position, player) do
        :move -> true
        :eat -> true
        :blocked -> false
      end
    end)
  end

  defp get_line_moves(board, {pos_x, pos_y} = piece_pos, player) do
    moves1 = line_iter(board, piece_pos, player, pos_x..7, :row)
    moves2 = line_iter(board, piece_pos, player, pos_x..0, :row)
    moves3 = line_iter(board, piece_pos, player, pos_y..7, :col)
    moves4 = line_iter(board, piece_pos, player, pos_y..0, :col)

    res = moves1 ++ moves2 ++ moves3 ++ moves4
    Enum.sort(res)
  end

  defp line_iter(board, {pos_x, pos_y} = piece_pos, player, range, type_iter) do
    range
    |> Enum.map(fn id ->
      if type_iter == :row do
        {id, pos_y}
      else
        {pos_x, id}
      end
    end)
    |> Enum.reject(&Kernel.==(&1, piece_pos))
    |> Enum.reduce_while([], fn position, acc ->
      case movement_action(board, position, player) do
        :move -> {:cont, [position | acc]}
        :eat -> {:halt, [position | acc]}
        :blocked -> {:halt, acc}
      end
    end)
    |> Enum.reverse()
  end

  defp get_diagonal_moves(board, piece_pos, player) do
    moves1 = diagonal_iter(board, piece_pos, player, :up_right, piece_pos)
    moves2 = diagonal_iter(board, piece_pos, player, :up_left, piece_pos)
    moves3 = diagonal_iter(board, piece_pos, player, :down_right, piece_pos)
    moves4 = diagonal_iter(board, piece_pos, player, :down_left, piece_pos)

    moves1 ++ moves2 ++ moves3 ++ moves4
  end

  defp diagonal_iter(_board, {pos_x, pos_y}, _player, _type, _piece_pos)
       when pos_x > 7 or pos_x < 0 or pos_y > 7 or pos_y < 0 do
    []
  end

  defp diagonal_iter(board, my_pos, player, type, original_pos) when my_pos == original_pos do
    new_pos = get_next_pos_diagonal(my_pos, type)
    diagonal_iter(board, new_pos, player, type, original_pos)
  end

  defp diagonal_iter(board, my_pos, player, type, original_pos) do
    case movement_action(board, my_pos, player) do
      :move ->
        new_pos = get_next_pos_diagonal(my_pos, type)
        positions = diagonal_iter(board, new_pos, player, type, original_pos)

        [my_pos | positions]

      :eat ->
        [my_pos]

      :blocked ->
        []
    end
  end

  defp get_next_pos_diagonal({x, y}, :up_right), do: {x + 1, y + 1}
  defp get_next_pos_diagonal({x, y}, :up_left), do: {x + 1, y - 1}
  defp get_next_pos_diagonal({x, y}, :down_right), do: {x - 1, y + 1}
  defp get_next_pos_diagonal({x, y}, :down_left), do: {x - 1, y - 1}

  defp movement_action(board, position, actual_player) do
    case Dashboard.get(board, position) do
      nil -> :move
      %{color: ^actual_player, type: _} -> :blocked
      %{color: _, type: _} -> :eat
    end
  end

  defp invalid_position?({x, y}), do: x > 7 or x < 0 or y > 7 or y < 0

  defp check_verify_and_move_filter(moves, _board, _piece, _piece_pos, false), do: moves

  defp check_verify_and_move_filter(moves, board, %{color: player} = piece, piece_pos, true) do
    # Generate scenario after movement, and then, reject any scenario where king can die.
    moves
    |> Enum.reject(fn position ->
      new_board = Dashboard.move(board, piece, position, piece_pos)
      in_check?(new_board, player)
    end)
  end

  # for tests ignore if there is no king in the board...
  defp king_can_die?(_board, nil, _player), do: false

  defp king_can_die?(board, king_pos, player) do
    other_player = if player == :white, do: :black, else: :white

    board
    |> Dashboard.get_player_pieces(other_player)
    |> Enum.any?(fn {piece, pos} ->
      piece
      |> movements(board, pos, false)
      |> Enum.member?(king_pos)
    end)
  end

  def can_move?(board, player) do
    board
    |> Dashboard.get_player_pieces(player)
    |> Enum.any?(fn {piece, pos} ->
      movements(piece, board, pos, false) == []
    end)
  end

  def any_move_without_check?(board, player) do
    board
    |> Dashboard.get_player_pieces(player)
    |> Enum.any?(fn {piece, piece_pos} ->
      moves = movements(piece, board, piece_pos, false)

      # check if there is any movement that, after it, we are not in check
      Enum.any?(moves, fn position ->
        new_board = Dashboard.move(board, piece, position, piece_pos)
        not in_check?(new_board, player)
      end)
    end)
  end

  defp get_moves_unless_blocked(board, move, player) do
    if movement_action(board, move, player) == :blocked do
      []
    else
      [move]
    end
  end
end

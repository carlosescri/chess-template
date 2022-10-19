defmodule ChessWeb.ChessLive do
  use Phoenix.LiveView, layout: {ChessWeb.LayoutView, "live.html"}

  alias Chess.Game
  alias Chess.Movements

  @impl Phoenix.LiveView
  def render(assigns) do
    ChessWeb.PageView.render("index.html", assigns)
  end

  @impl Phoenix.LiveView
  def mount(%{"id" => id}, _session, socket) do
    socket =
      socket
      |> assign(:game, %Game{name: String.to_atom(id)})

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "select_cell",
        %{"x" => x, "y" => y},
        %{assigns: %{game: %{board: %{cells: cells}, initial_position: nil}}} = socket
      ) do
    {x, _} = Integer.parse(x)
    {y, _} = Integer.parse(y)

    socket =
      socket
      |> Phoenix.LiveView.clear_flash()
      |> set_initial_position({x, y}, Map.get(cells, {x, y}))

    {:noreply, socket}
  end

  def handle_event(
        "select_cell",
        %{"x" => x, "y" => y},
        %{assigns: %{game: %{board: %{cells: cells}, initial_position: initial_position}}} =
          socket
      ) do
    {x, _} = Integer.parse(x)
    {y, _} = Integer.parse(y)
    socket = Phoenix.LiveView.clear_flash(socket, :error)
    piece = Map.get(cells, initial_position)

    socket =
      cells
      |> Movements.movement(piece, initial_position, {x, y})
      |> then(&attack_and_move(socket, &1, piece, initial_position, {x, y}))

    {:noreply, socket}
  end

  # Means the user click again over the same piece so we unselect it
  defp attack_and_move(socket, _, _piece, position, position),
    do: update_game_status(socket, [Access.key(:initial_position)], nil)

  defp attack_and_move(socket, :error, _piece, _, _), do: error_message(socket, "Wrong movement")

  defp attack_and_move(socket, {:ok, nil}, piece, initial_position, final_position),
    do: move_piece(socket, piece, initial_position, final_position)

  defp attack_and_move(
         %{assigns: %{game: game}} = socket,
         {:ok, removed_piece},
         piece,
         initial_position,
         final_position
       ),
       do:
         game
         |> get_in([Access.key(removed_piece.color), :removed_pieces])
         |> Enum.concat([removed_piece])
         |> then(
           &update_game_status(socket, [Access.key(removed_piece.color), :removed_pieces], &1)
         )
         |> move_piece(piece, initial_position, final_position)

  defp change_player(%{assigns: %{game: %{next_player: :white}}}), do: :black

  defp change_player(%{assigns: %{game: %{next_player: :black}}}), do: :white

  defp error_message(socket, msg), do: Phoenix.LiveView.put_flash(socket, :error, msg)

  defp move_piece(
         %{assigns: %{game: %{board: %{cells: cells} = board}}} = socket,
         piece,
         initial_position,
         final_position
       ),
       do:
         cells
         |> Map.put(final_position, piece)
         |> Map.put(initial_position, nil)
         |> then(&Map.put(board, :cells, &1))
         |> then(&update_game_status(socket, &1, nil, nil, change_player(socket)))

  defp set_initial_position(socket, _position, nil),
    do: error_message(socket, "Select a cheese piece to move")

  defp set_initial_position(%{assigns: %{game: %{next_player: color}}} = socket, position, %{
         color: color
       }),
       do: update_game_status(socket, [Access.key(:initial_position)], position)

  defp set_initial_position(
         %{assigns: %{game: %{next_player: color}}} = socket,
         _position,
         _piece
       ),
       do: error_message(socket, "It is #{color} player turn")

  defp update_game_status(%{assigns: %{game: game}} = socket, key, value),
    do:
      game
      |> put_in(key, value)
      |> then(&assign(socket, :game, &1))

  defp update_game_status(
         %{assigns: %{game: game}} = socket,
         board,
         initial_position,
         final_position,
         next_player
       ),
       do:
         game
         |> Map.put(:board, board)
         |> Map.put(:initial_position, initial_position)
         |> Map.put(:final_position, final_position)
         |> Map.put(:next_player, next_player)
         |> then(&assign(socket, :game, &1))
end

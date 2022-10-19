defmodule ChessWeb.ChessGameLive do
  use ChessWeb, :live_view

  require Integer

  alias Chess.ChessGenServer
  alias Chess.Structs.Figure
  alias Phoenix.LiveView

  # TODO add other types
  @figures [king: %Figure{type: "king", steps: 1}]

  @impl LiveView
  def mount(%{"game_name" => game_name}, _session, socket) do
    name = String.to_atom(game_name)
    ChessGenServer.start_link(name)

    {:ok, board} = ChessGenServer.join(name)

    {
      :ok,
      socket
      |> assign(game_name: name)
      |> assign(board: board)
      |> assign(moving: "")
    }
  end

  def handle_event(
        "clicked_figure",
        %{"position" => position},
        %{assigns: %{moving: ""}} = socket
      ) do
    {:noreply, assign(socket, moving: position)}
  end

  def handle_event(
        "clicked_figure",
        %{"position" => position},
        %{assigns: %{game_name: game_name, moving: from, board: board}} = socket
      ) do
    [from_row, from_column] = String.split(from, ",")
    from_row = String.to_integer(from_row)
    from_column = String.to_integer(from_column)
    [position_row, position_column] = String.split(position, ",")
    position_row = String.to_integer(position_row)
    position_column = String.to_integer(position_column)

    moved_figure =
      board
      |> Enum.at(from_row)
      |> Enum.at(from_column)

    current_figure =
      board
      |> Enum.at(position_row)
      |> Enum.at(position_column)

    updated_board =
      if move_allowed?(moved_figure, current_figure) do
        board
        |> List.update_at(from_row, fn columns ->
          List.replace_at(columns, from_column, {nil, nil})
        end)
        |> List.update_at(position_row, fn columns ->
          List.replace_at(columns, position_column, moved_figure)
        end)
      else
        board
      end

    {:ok, _} = ChessGenServer.update_board(game_name, updated_board)

    {
      :noreply,
      socket
      |> assign(moving: "")
      |> assign(board: updated_board)
    }
  end

  @impl true
  def handle_info({:update_board, board}, socket) do
    {:noreply, assign(socket, board: board)}
  end

  defp move_allowed?(new_figure, current_figure) do
    # TODO Replace return boolean by data + valid.
    # Also add here other restrictions using figure struct to check movements
    validate_empty(new_figure, current_figure)
  end

  defp validate_empty({_, new_color}, {nil, current_color}) when new_color != current_color,
    do: true

  defp validate_empty(_, _), do: false

  defp figure?(nil, nil), do: false
  defp figure?(_, _), do: true
end

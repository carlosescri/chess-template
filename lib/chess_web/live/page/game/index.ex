defmodule ChessWeb.GameLive.Index do

  use ChessWeb, :live_view

  alias Chess.Dashboard
  alias ChessWeb.SquareLiveComponent
  alias Chess.FigureMove
  alias Chess.Board

  def mount(_params, _session, socket) do
    {:ok, assign_initial_game(socket)}
  end

  def handle_event("select", %{"player" => figure_color, "cor" => cor } = params,
  %{assigns: %{move: nil, selected_figure: nil,
  board: board, player: player}} = socket) do
    case figure_color == player do
      true -> move = FigureMove.move(params)
      coordinate = String.to_atom(cor)
      selected_coordinate = Map.get(board, coordinate)
      {:noreply, socket
        |> assign(move: move)
        |> assign(selected_figure: Map.get(selected_coordinate, :figure))
        |> assign(prev_coordinate: coordinate )
      }
      false -> {:noreply, socket}
    end
  end

  def handle_event("select", %{"player" => figure_color, "cor" => cor } = params,
  %{assigns: %{move: move, selected_figure: selected_figure,
  board: board, prev_coordinate: prev_coordinate, player: player}} = socket) do
    case FigureMove.kill?(params, prev_coordinate, player) do
      true -> update_board(cor, socket)
      false -> {:noreply, socket}
    end
  end

  def handle_event("select", %{"cor" => cor}, socket) do
    move = socket.assigns.move || []
    case Enum.member?(move, cor) do
      true -> update_board(cor, socket)
      false -> {:noreply, socket}
    end
  end

  defp assign_initial_game(socket) do
    {new_board, coordinates} = Dashboard.build_dashboard()
    socket
    |> assign(board: new_board)
    |> assign(coordinates: coordinates)
    |> assign(player: "white")
    |> assign(move: nil)
    |> assign(selected_figure: nil)
  end

  defp update_board(cor, socket) do
    coordinate = String.to_atom(cor)

    first_change = socket.assigns.board
    |> Map.get(socket.assigns.prev_coordinate)
    |> Map.replace(:figure, nil)

    second_change = socket.assigns.board
    |> Map.get(coordinate)
    |> Map.replace(:figure, socket.assigns.selected_figure)

    board = socket.assigns.board
    |> Map.replace(coordinate, second_change)
    |> Map.replace(socket.assigns.prev_coordinate, first_change)

    player = case socket.assigns.player == "white" do
      true -> "black"
      false -> "white"
    end

    {:noreply,
      socket
        |> assign(board: board)
        |> assign(player: player)
        |> assign(move: nil)
        |> assign(selected_figure: nil)
    }
  end

end

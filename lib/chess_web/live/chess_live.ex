defmodule ChessWeb.ChessLive do
  use ChessWeb, :live_view
  alias ChessWeb.Endpoint
  alias Chess.Board
  alias Chess.State
  alias Chess.Move

  @player_order %{"white" => "black", "black" => "white"}
  def mount(params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(params["id"])
    end

    socket =
      socket
      |> assign(board: %Board{})
      |> assign(selected_square: nil)
      |> assign(selected_figure: nil)
      |> assign(turn: "white")
      |> assign(id: params["id"])
      |> assign(won: nil)
      |> assign_new(:white, fn -> socket.id end)
      |> assign_new(:black, fn -> nil end)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    assigns = Map.get(State.value(), params["id"])

    socket =
      if is_nil(assigns) do
        socket
      else
        socket
        |> assign(board: assigns.board)
        |> assign(selected_square: assigns.selected_square)
        |> assign(selected_figure: assigns.selected_figure)
        |> assign(turn: assigns.turn)
        |> assign(white: assigns.white)
        |> then(
          &if &1.assigns.white != &1.id and not is_nil(&1.assigns.white),
            do: assign(&1, black: &1.id)
        )
      end

    State.set(socket.assigns, params["id"])

    {:noreply, socket}
  end

  def handle_info({:state, state}, socket) do
    {:noreply,
     socket
     |> assign(board: state.board)
     |> assign(white: state.white)
     |> assign(black: state.black)
     |> assign(turn: state.turn)
     |> assign(won: state.won)}
  end

  def handle_event(
        "move_select",
        %{
          "square" => square,
          "selected_figure" => selected_figure,
          "selected_square" => selected_square
        },
        socket
      ) do
    square_atom = String.to_existing_atom(square)
    selected_square_atom = String.to_existing_atom(selected_square)
    player = String.split(selected_figure, " ") |> Enum.at(1)
    posible_places = get_posible_places(selected_figure, selected_square, square, socket)

    socket =
      if Enum.member?(posible_places, square_atom) do
        socket
        |> update(:board, &Map.put(&1, square_atom, selected_figure))
        |> update(:board, &Map.put(&1, selected_square_atom, nil))
        |> assign(turn: @player_order[player])
        |> clear_flash()
      else
        socket
        |> put_flash(:error, "Invalid movement")
      end

    socket =
      socket
      |> assign(selected_square: nil)
      |> assign(selected_figure: nil)

    State.set(socket.assigns, socket.assigns.id)

    {:noreply, socket}
  end

  def handle_event(
        "move_select",
        %{"square" => square, "figure" => figure},
        socket
      ) do
    player = String.split(figure, " ") |> Enum.at(1)
    user = Map.get(socket.assigns, String.to_atom(player))

    socket =
      if player != socket.assigns.turn or socket.id != user do
        put_flash(socket, :error, "Not your turn")
      else
        socket
        |> assign(selected_square: square)
        |> assign(selected_figure: figure)
        |> clear_flash()
      end

    {:noreply, socket}
  end

  def handle_event("move_select", %{"square" => _}, socket) do
    {:noreply, socket}
  end

  defp get_posible_places(selected_figure, selected_square, square, socket) do
    selected_figure
    |> Move.validate_move(
      selected_square,
      square,
      socket.assigns.board,
      socket.assigns.turn,
      socket.assigns.id
    )
    |> Enum.map(fn {x, y} -> Board.from_position_to_square(x, y) |> String.to_existing_atom() end)
  end
end

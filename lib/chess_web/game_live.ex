defmodule ChessWeb.GameLive do
  @moduledoc """
  This module contains the logic needed to play a chass game. There is a live
  view which renders the board, fetchees the information about the pieces and
  has the events to move them.any()

  Uses the GameServer to deal with the information shared accros the different
  tabs playing the game.
  """

  use ChessWeb, :live_view

  import ChessWeb.Board

  alias ChessWeb.BoardLive
  alias ChessWeb.GameServer
  alias ChessWeb.BoardLive.Components

  @chess_game_topic "chess_game"

  @doc """
  In the mount function the information with the pieces is fetched from the
  GameServer.

  Also, it connect to a channel to receive information about the movements
  done.
  """
  @impl Phoenix.LiveView
  def mount(%{"game_name" => game_name}, _session, socket) do
    pid = Process.whereis(GameServer)
    pieces = GameServer.get_pieces(pid)
    topic_name = "#{@chess_game_topic}-#{game_name}"
    if connected?(socket) do
      ChessWeb.Endpoint.subscribe(topic_name)
    end

    {:ok,
    socket
    |> assign(:game_name, nil)
    |> assign(:chess_game_topic_id, topic_name)
    |> assign(:pid, pid)
    |> assign(:selected_square, nil)
    |> assign_pieces()}
  end

  @doc """
  There is a param received, the name of the game, fetched from the path
  /:game_name. This game name can be shared by the users to join the same game

  Example:
    http://localhost:4000/my_game
  """
  @impl Phoenix.LiveView
  @spec handle_params(%{:game_name => binary()}, any, map) :: {:noreply, map}
  def handle_params(%{"game_name" => game_name}, _uri, socket) do
    {
      :noreply,
      socket
      |> assign(:game_name, game_name)
    }
  end

  @doc """
  This function handles the information send by the GameServer when a change is
  made, so the information about the position of the pieces can be refreshed.
  """
  def handle_info(%{event: "piece_moved"}, socket) do
    {:noreply,
      socket
      |> assign_pieces()
      |> assign(:selected_square, nil)}
  end

  @doc """
  Fetched the position of the pieces from the GameServer
  """
  defp assign_pieces(socket) do
    pieces = GameServer.get_pieces(socket.assigns.pid)
    assign(socket, :pieces, pieces)
  end

  # Board

  @doc """
  Renders the board dinamically and draw the pieces in their positions.

  ## Usage

      <.board
        pieces=[piece1, piece2]
        selected_square=string>
        Board content
      </.board>

  `pieces` has the information about the position of the pieces.
  `selected_squeare` has the squeare already selected. E.g.: "25"
  """
  defp board(assigns) do
    assigns = assign_new(assigns, :selected_square, fn -> nil end)

    ~H"""
    <section>
      <div class="board">
        <%= for y <- 8..1 do %>
          <%= for x <- 1..8 do %>
            <div class={"square #{get_square_color(y, x, @selected_square)}"}
              phx-click="move_piece_to"
              phx-value-square={"#{y}#{x}"}
            >
              <%= if draw_piece(x, y, @pieces) do %>
                <div class={"figure #{draw_piece(x, y, @pieces)}"}
                  phx-click="move_piece_from"
                  phx-value-square={"#{y}#{x}"}
            />
              <% end %>
            </div>
          <% end %>
        <% end %>
      </div>
    </section>
    """
  end

  @doc """
  In this function, the received assigns are passed to the assigns of the view.

  Initialices the extra assign for the selected square.
  """
  def update(assigns, socket) do
    {:ok,
    socket
    |> assign(:chess_game_topic_id, assigns.id)
    |> assign(:pieces, assigns.pieces)
    |> assign(:selected_square, nil)}
    end

  @doc """
  This event is sent when a user starts a movement and receives the clicked square.

  As a result, the selected square is stored in the assigns to be used later.

  In first place, the users chooses the square with the piece they want to move
  and it is completed with the event "move_piece_to" (see below).

  This event can only be sent by squeares with pieces in it, as it is attached
  to the div containing the piece.
  """
  @impl Phoenix.LiveView
  def handle_event("move_piece_from", %{"square" => square}, socket) do
    IO.inspect(square)
    selected_square = socket.assigns.selected_square
    IO.inspect(selected_square)
    if square == selected_square do
      selected_square == nil
    end
    {:noreply, assign(socket, :selected_square, square)}
  end

  @doc """
  This event is sent when a user finish a movement and receives the final square.

  This event has to take place only when the event "move_piece_from" has been
  fired, so the selected_square is not nill in the assigns.

  If the movement is right, it is done, firing the function "move_piece" in the
  GameServer and it is updated.

  This event is attached to any square of the board.
  """
  @impl Phoenix.LiveView
  def handle_event("move_piece_to", _, %{assigns: %{selected_square: nil}} = socket), do: {:noreply, socket}

  def handle_event(
    "move_piece_to",
    %{"square" => square},
    %{assigns: %{selected_square: selected_square}} = socket) do
    GameServer.move_piece(socket.assigns.pid, %{"old_square" => selected_square, "new_square" => square})
    {:noreply, handle_piece_moved(socket, square)}
  end

  @doc """
  This function is launched when a movement has been done and sent a
  broadcasted message to any listening tab, so the know the need to update the
  position of the pieces.

  Also, a flash message is displayed to let the user know that the movement has
  been done.
  """
  def handle_piece_moved(
    %{assigns: %{pieces: pieces, selected_square: selected_square}} = socket,
    square
  ) do
    ChessWeb.Endpoint.broadcast(socket.assigns.chess_game_topic_id, "piece_moved", %{})
    socket
    |> put_flash(:info, "Movement submitted successfully")
    |> assign(:selected_square, nil)
  end
end

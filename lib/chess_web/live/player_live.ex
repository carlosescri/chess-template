defmodule ChessWeb.PlayerLive do
  use ChessWeb, :live_view
  require Integer

  alias Chess.GameServer
  alias Chess.Game

  @impl Phoenix.LiveView
  def mount(%{"game_name" => game_name}, _session, socket) do
    {:ok,
     socket
     |> assign(game_name: String.to_atom(game_name))
     |> assign(player: :white)
     |> assign(state: nil)
     |> assign(cell_selected: nil)}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket) do
    GameServer.start_link(socket.assigns.game_name)

    if connected?(socket) do
      with {:ok, state, player} <- GameServer.join(socket.assigns.game_name) do
        {:noreply,
         socket
         |> assign(state: state, player: player)
         |> set_turn(state)}
      else
        {:error, msg} ->
          {:noreply,
           socket
           |> put_flash(:error, msg)
           |> redirect(to: Routes.page_path(socket, :index))}
      end
    else
      {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("click-cell", _params, socket)
      when socket.assigns.state.turn != socket.assigns.player do
    {:noreply, socket}
  end

  def handle_event(
        "click-cell",
        %{"x" => x, "y" => y},
        %{assigns: %{cell_selected: nil}} = socket
      ) do
    {:noreply,
     socket
     |> assign(cell_selected: {String.to_integer(x), String.to_integer(y)})
     |> clear_flash(:error)}
  end

  def handle_event("click-cell", %{"x" => x, "y" => y}, socket) do
    x = String.to_integer(x)
    y = String.to_integer(y)

    my_pieces = Map.get(socket.assigns.state, socket.assigns.player)

    socket =
      case Game.find_piece(socket.assigns.cell_selected, my_pieces) do
        nil -> socket
        piece -> move(socket, piece, {x, y})
      end

    {:noreply, assign(socket, cell_selected: nil)}
  end

  @impl Phoenix.LiveView
  def handle_info({:opponent_moved, new_state}, socket) do
    {:noreply,
     socket
     |> set_turn(new_state)
     |> assign(state: new_state)}
  end

  def handle_info({:opponent_won, new_state}, socket) do
    {:noreply,
     socket
     |> clear_flash(:info)
     |> put_flash(:warning, "KING IS DEAD. Your opponent has won.")
     |> assign(state: new_state)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section>
      <div class="board">
      <%= for y <- cells_list(@player) do %>
        <%= for x <- cells_list(@player) do %>
          <.cell x={x}
                 y={y}
                 content={cell_content({x,y}, @state)}
                 selected={@cell_selected == {x,y}}
                 color={if Integer.is_even(x+y), do: "white", else: "black"}/>
        <% end %>
      <% end %>
      </div>
    </section>
    """
  end

  defp cell(assigns) do
    ~H"""
      <div id={"cell-#{@x}-#{@y}"}
           class={"square #{@color} #{if @selected, do: "selected"}"}
           phx-click="click-cell"
           phx-value-x={@x}
           phx-value-y={@y}>
        <%= if @content do %>
          <div class={"figure #{@content.player} #{@content.piece}"}></div>
        <% end %>
      </div>
    """
  end

  defp cells_list(:white), do: 7..0
  defp cells_list(:black), do: 0..7

  defp cell_content(_position, nil), do: nil

  defp cell_content(position, state), do: find_pieces(position, state, [:white, :black])

  defp find_pieces(position, state, [player | rest]) do
    case Game.find_piece(position, Map.get(state, player)) do
      nil -> find_pieces(position, state, rest)
      piece -> %{player: player, piece: piece.type}
    end
  end

  defp find_pieces(_position, _state, []), do: nil

  defp set_turn(socket, state) do
    if socket.assigns.player == state.turn do
      put_flash(socket, :info, "It's your turn. Move!")
    else
      put_flash(socket, :info, "It's the opponent turn. Wait.")
    end
  end

  defp move(socket, piece, position) do
    case GameServer.move(socket.assigns.game_name, {piece, position}) do
      {:ok, state} ->
        socket
        |> set_turn(state)
        |> assign(state: state)

      {:king_died, state} ->
        socket
        |> clear_flash(:info)
        |> put_flash(:warning, "KING IS DEAD. You won! Congratulations.")
        |> assign(state: state)

      {:error, "illegal movement"} ->
        put_flash(socket, :error, "Your piece can't move that way. Try again.")
    end
  end
end

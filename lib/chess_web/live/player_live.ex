defmodule ChessWeb.PlayerLive do
  use ChessWeb, :live_view
  require Integer

  alias Chess.GameServer

  @impl Phoenix.LiveView
  def mount(%{"game_name" => game_name}, _session, socket) do
    {:ok,
     socket
     |> assign(game_name: String.to_atom(game_name))
     |> assign(player: :white)
     |> assign(state: nil)
     |> assign(cell_selected: nil)}
  end

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

  def handle_event(
        "click-cell",
        %{"x" => x, "y" => y},
        socket
      )
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
      case find_piece(socket.assigns.cell_selected, my_pieces) do
        {:found, piece} -> move(socket, piece, {x, y})
        :not_found -> socket
      end

    {:noreply, assign(socket, cell_selected: nil)}
  end

  def handle_info({:opponent_moved, new_state}, socket) do
    {:noreply,
     socket
     |> set_turn(new_state)
     |> assign(state: new_state)}
  end

  def render(assigns) do
    ~H"""
    <section>
      <div class="board">
      <%= for y <- cells_list(@player) do %>
        <%= for x <- cells_list(@player) do %>
          <div
           id={"cell-#{x}-#{y}"}
           class={"square #{if Integer.is_even(x+y), do: "white", else: "black"}"}
           phx-click="click-cell"
           phx-value-x={x}
           phx-value-y={y}>
            <.cell content={cell_content({x,y}, @state)} />
          </div>
        <% end %>
      <% end %>
      </div>
    </section>
    """
  end

  defp cell(%{content: {piece, player}} = assigns) do
    ~H"""
      <div class={"figure #{player} #{piece}"}></div>
    """
  end

  defp cell(assigns),
    do: ~H"""
    """

  defp cells_list(:white), do: 7..0
  defp cells_list(:black), do: 0..7

  defp cell_content(position, nil), do: nil

  defp cell_content(position, state) do
    case find_piece(position, state.white) do
      {:found, piece} ->
        {piece.type, :white}

      :not_found ->
        case find_piece(position, state.black) do
          {:found, piece} -> {piece.type, :black}
          :not_found -> nil
        end
    end
  end

  defp find_piece(position, [piece | rest]) do
    if piece.position == position do
      {:found, piece}
    else
      find_piece(position, rest)
    end
  end

  defp find_piece(_position, []), do: :not_found

  defp set_turn(socket, state) do
    if socket.assigns.player == state.turn do
      put_flash(socket, :info, "It's your turn. Move!")
    else
      put_flash(socket, :info, "It's the opponent turn. Wait.")
    end
  end

  defp move(socket, piece, position) do
    case GameServer.move(socket.assigns.game_name, {piece, position}) do
      {:ok, state} -> socket |> set_turn(state) |> assign(state: state)
      {:error, msg} -> put_flash(socket, :error, msg)
    end
  end
end

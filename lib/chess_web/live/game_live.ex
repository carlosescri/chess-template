defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  alias Chess.Gameplay.Game
  alias Chess.Gameplay.Position

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :timer.send_interval(1000, self(), :tick)
    end

    {:ok, assign(socket, state: Game.initial(), selected_pos: nil) |> assign_current_time()}
  end

  @impl true

  @impl true
  def handle_event("select_sq", %{"pos" => pos}, socket) do
    with {:ok, pos} <- Position.parse(pos) do
      case socket.assigns.selected_pos do
        ^pos ->
          {:noreply,
            socket
            |> assign(selected_pos: nil)}

        _ ->
          case socket.assigns.selected_pos do
            nil ->
              {:noreply, socket |> assign(selected_pos: pos)}

            from_p ->
              with {:ok, state} <-
                     Game.move(socket.assigns.state, from_p, pos) do
                {:noreply, assign(socket, state: state, selected_pos: nil)}
              else
                {:error, msg} ->
                  {:noreply, socket |> put_flash(:error, msg)}
              end
          end
      end
    else
      {:error, msg} -> {:noreply, socket |> put_flash(:error, msg)}
    end
  end

  @impl true
  def handle_event("incr", _, socket) do
    {:noreply, socket |> assign(counter: socket.assigns[:counter] + 1)}
  end

  @impl true
  def handle_info(:tick, socket) do
    socket = assign_current_time(socket)

    {:noreply, socket}
  end

  def assign_current_time(socket) do
    now =
      Time.utc_now()
      |> Time.to_string()
      |> String.split(".")
      |> hd

    assign(socket, now: now)
  end

  def get_classes(selected_pos, col, row) do
    colour =
      case rem(row + col, 2) do
        0 -> :black
        1 -> :white
      end
    selected =
      case selected_pos == {col, row} do
        true -> "selected"
        _ -> ""
      end
    "square #{colour} #{selected}"
  end

  def pos_to_s({c, r}), do: "#{c},#{r}"
  def pos_to_s(nil), do: nil

  def piece_render(nil), do: nil

  def piece_render(%{type: piece, colour: :white}) do
    case piece do
      :pawn -> "figure white pawn"
      :knight -> "figure white knight"
      :bishop -> "figure white bishop"
      :rook -> "figure white rook"
      :queen -> "figure white queen"
      :king -> "figure white king"
    end
  end

  def piece_render(%{type: piece, colour: :black}) do
    case piece do
      :pawn -> "figure black pawn"
      :knight -> "figure black knight"
      :bishop -> "figure black bishop"
      :rook -> "figure black rook"
      :queen -> "figure black queen"
      :king -> "figure black king"
    end
  end

  def outcome(%{outcome: :checkmate, turn: turn}), do: "#{turn} lost, checkmate!"
  def outcome(%{outcome: :stalemate}), do: "Tie by stalemate!"
  def outcome(_), do: nil
end

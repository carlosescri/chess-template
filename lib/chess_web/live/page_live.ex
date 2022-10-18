defmodule ChessWeb.PageLive do
  use ChessWeb, :live_view

  require IO

  alias Phoenix.LiveView.Socket

  ##########
  # EVENTS #
  ##########

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, assign_init(socket)}
  end

  @impl Phoenix.LiveView
  def handle_params(_params, _, socket) do
    new_socket =
      if connected?(socket) do
        socket
        |> push_event("restore", %{username: "username", room: "room"})
      else
        socket
      end

    {:noreply, new_socket}
  end

  @impl Phoenix.LiveView
  def handle_event("restoreSettings", _data, socket) do
    {:noreply, socket}
  end

  def handle_event("from", data, socket) do
    IO.puts("################ JS ################")
    IO.inspect(data)

    socket =
      # if "from" exists is event "to"
      if socket.assigns.from != nil do
        # Check if figure can move
        move = can_move?(socket.assigns.from["figure"], "white", socket.assigns.from["position"], data["position"], false)
        # Comunicate with draw in JS
        push_event(assign(socket, :from, nil), "to", %{from: socket.assigns.from["position"], to: data["position"], move: move})
      else
        assign(socket, :from, data)
      end

    {:noreply, socket}
  end

  def handle_event("kill", data, socket) do
    IO.puts("################ KILL ################")
    IO.inspect(data)

    move = can_move?("pawn", "white", data["from"], data["to"], true)
    IO.inspect(move)
    socket = if move == true, do: push_event(socket, "forceDraw", %{from: socket.assigns.from["position"], to: data["position"], move: move})
    {:noreply, assign(socket, :from, nil)}
  end

  ###########
  # PRIVATE #
  ###########

  @spec assign_init(Socket.t()) :: Socket.t()
  defp assign_init(socket) do
    socket
    |> assign(:from, nil)
    |> assign(:to, nil)
  end

  ########
  # PAWN #
  ########

  defp can_move?("pawn", "white", old, new, false) do
    {ox, oy} = get_xy(old)
    {nx, ny} = get_xy(new)

    if first_move?("white", oy) do
      (oy - ny == 1 or oy - ny == 2 ) and (ox - nx == 0)
    else
      (oy - ny == 1 and ox - nx == 0)
    end
  end

  defp can_move?("pawn", "white", old, new, true) do
    {ox, oy} = get_xy(old)
    {nx, ny} = get_xy(new)

    oy - ny == 1 or ox - nx == 1
  end

  defp can_move?(_figure, _color, _old, _new, _kill) do
    true
  end

  defp get_xy(value) do
    data = Regex.run(~r"(.*)-(.*)", value)
    {
      String.to_integer(Enum.at(data, 2)),
      String.to_integer(Enum.at(data, 1)),
    }
  end

  def first_move?("black", _y) do
    false
  end

  def first_move?("white", y) do
    y == 6
  end

  def other_figure?(_position) do
    false
  end

end

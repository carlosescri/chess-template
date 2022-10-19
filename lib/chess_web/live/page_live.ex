defmodule ChessWeb.PageLive do
  use ChessWeb, :live_view

  require IO

  alias ChessWeb.Endpoint
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
  def handle_event("restore", data, socket) do
    if connected?(socket) do
      Endpoint.subscribe(data["room"])
    end
    {
      :noreply,
      socket
      |> assign(:topic, data["room"])
      |> assign(:username, data["username"])
    }
  end

  def handle_event("from", data, socket) do
    # if "from" exists is event "to"
    socket =
      if socket.assigns.from != nil do
        # Check if figure can move
        move = can_move?(socket.assigns.from["figure"], socket.assigns.iam, socket.assigns.from["position"], data["position"], false)
        # Send data to ws
        send = %{player: socket.assigns.iam, from: socket.assigns.from["position"], to: data["position"], move: move}
        ChessWeb.Endpoint.broadcast(socket.assigns.topic, "move", send)
        socket
      else
        assign(socket, :from, data)
      end

    {:noreply, socket}
  end

  def handle_event("kill", data, socket) do
    move = can_move?("pawn", socket.assigns.iam, data["from"], data["to"], true)
    socket = if move == true, do: push_event(socket, "forceDraw", %{from: data["from"], to: data["to"], move: move}), else: socket
    {:noreply, assign(socket, :from, nil)}
  end

  @impl Phoenix.LiveView
  def handle_info(%{event: "move", payload: message}, socket) do
    {
      :noreply,
      socket
      |> assign(:from, nil)
      # Comunicate with draw in JS
      |> push_event("to", %{from: message.from, to: message.to, move: message.move})
    }

  end


  @spec assign_init(Socket.t()) :: Socket.t()
  defp assign_init(socket) do
    socket
    |> assign(:from, nil)
    |> assign(:to, nil)
    |> assign(:iam, "white")
  end

  ########
  # PAWN #
  ########

  defp can_move?("pawn", "white", old, new, false) do
    {ox, oy} = get_xy(old)
    {nx, ny} = get_xy(new)

    if first_move?("white", oy) do
      (oy - ny == 1 or oy - ny == 2) and (ox - nx == 0)
    else
      (oy - ny == 1 and ox - nx == 0)
    end
  end

  defp can_move?("pawn", "white", old, new, true) do
    {ox, oy} = get_xy(old)
    {nx, ny} = get_xy(new)

    (abs(oy - ny) == 1 and abs(ox - nx) == 1)
  end

  ########
  # ROOK #
  ########

  defp can_move?("rook", _color, old, new, false) do
    {ox, oy} = get_xy(old)
    {nx, ny} = get_xy(new)

    (abs(oy - ny) > 0 and abs(ox - nx) == 0) or (abs(oy - ny) == 0 and abs(ox - nx) > 0)
  end

  defp can_move?("rook", _color, _old, _new, true) do
    false
  end

  ##########
  # KNIGHT #
  ##########

  defp can_move?("knight", _color, old, new, false) do
    {ox, oy} = get_xy(old)
    {nx, ny} = get_xy(new)

    (abs(ox - nx) == 2 and abs(oy - ny) == 1) or (abs(oy - ny) == 2 and abs(ox - nx) == 1)
  end

  defp can_move?("knight", _color, _old, _new, true) do
    false
  end

  ########
  # KING #
  ########

  defp can_move?("king", _color, old, new, false) do
    {ox, oy} = get_xy(old)
    {nx, ny} = get_xy(new)

    movX = nx - ox
    movY = ny - oy

    (movX >= -1 and movX <= 1 and movY >= -1 and movY <= 1)
  end

  defp can_move?("king", _color, _old, _new, true) do
    false
  end

  #########
  # QUEEN #
  #########

  defp can_move?("queen", _color, old, new, false) do
    {ox, oy} = get_xy(old)
    {nx, ny} = get_xy(new)

    (ox == nx or oy == ny or abs(ny - oy) == abs(ny - oy))
  end

  defp can_move?("queen", _color, _old, _new, true) do
    false
  end

  defp can_move?(_figure, _color, _old, _new, _kill) do
    true
  end

  #########
  # UTILS #
  #########

  # This is for the pawn. To know if it's the first movement
  defp first_move?("black", y) do
    y == 1
  end

  defp first_move?("white", y) do
    y == 6
  end###


  # Get Y,X from html ids
  defp get_xy(value) do
    data = Regex.run(~r"(.*)-(.*)", value)
    {
      String.to_integer(Enum.at(data, 2)),
      String.to_integer(Enum.at(data, 1)),
    }
  end

end

defmodule ChessWeb.GameLive do
  use Phoenix.LiveView, layout: {ChessWeb.LayoutView, "live.html"}

  alias Chess.GameServer
  alias ChessWeb.SettingStruct

  def mount(%{"id" => id}, _session, socket) do
    game_name = String.to_atom(id)
    socket = assign(socket, new(game_name))
    GameServer.start_link(socket.assigns.game_name)

    case GameServer.join(socket.assigns.game_name) do
      {:ok, state} ->
        ready =
          {:ok,
           assign(socket,
             mode: :setting,
             state: %SettingStruct{board: state.board},
             info: "CLICK A FIGURE!"
           )}
        ready

      {:error, _msg} ->
        {:ok, assign(socket, mode: :not_allowed)}
    end
  end

  def render(assigns) do
    ChessWeb.PageView.render("game_live.html", assigns)
  end

  def new(game_name) do
    %{
      game_name: game_name,
      mode: nil,
      state: nil,
      info: ""
    }
  end

  def handle_event(
        "cell_selected",
        %{"row" => row, "column" => column},
        %{assigns: %{mode: :setting, state: %SettingStruct{first_cell_selected: nil}}} = socket
      ) do
    cell = {String.to_integer(row), String.to_integer(column)}
    state = %{socket.assigns.state | first_cell_selected: cell}

    {:noreply, assign(socket, state: state, info: "CLICK CELL: {#{row}, #{column}}")}
  end

  def handle_event("cell_selected", _params, socket), do: {:noreply, socket}
end

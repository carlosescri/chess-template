defmodule ChessWeb.PlayerChessLive do
  use Phoenix.LiveView, layout: {ChessWeb.LayoutView, "live.html"}
  # alias Chess.Operations
  # alias Chess.Game
  alias Chess.GameServer
  alias ChessWeb.SettingStruct
  alias ChessWeb.PlayingStruct
  # alias ChessWeb.GameOverStruct

  def new(game_name) do
    %{
      game_name: game_name,
      mode: nil,
      state: nil,
      info: ""
    }
  end

  def render(assigns) do
    ChessWeb.PageView.render("player_game_live.html", assigns)
  end

  def mount(%{"id" => id}, _session, socket) do
    game_name = String.to_atom(id)
    socket = assign(socket, new(game_name))
    GameServer.start_link(socket.assigns.game_name)

    case GameServer.join(socket.assigns.game_name) do
      {:ok, state} ->
        {:ok,
         assign(socket,
           mode: :playing,
           settings: %SettingStruct{ready: false},
           players: %PlayingStruct{},
           state: state,
           info: "You have the first move! Good luck!"
         )}

      {:error, _msg} ->
        {:ok, assign(socket, mode: :not_allowed)}
    end
  end

  # - Events for setting state -------------------------
  def handle_event(
        "cell_selected",
        %{"row" => row, "column" => column},
        %{assigns: %{mode: :playing, players: players, settings: settings}} = socket
      )
      when settings.piece_selected == nil do
    {String.to_integer(row), String.to_integer(column)}
    |> check_have_piece(players.you)
    |> select_piece(socket)
  end

  def handle_event(
        "cell_selected",
        %{"row" => row, "column" => column},
        %{assigns: %{mode: :playing, players: players, settings: settings}} = socket
      )
      when settings.piece_selected != nil do
    new_position = {String.to_integer(row), String.to_integer(column)}

    new_position
    |> check_colision(players)
    |> make_move(new_position, players.you, socket)
  end

  # defp define_players(playing_struct, :player1) do
  #   your_structure = Map.put(playing_struct.you, :player, :player1)
  #   enemy_structure = Map.put(playing_struct.enemy, :player, :player2)

  #   playing_struct |> Map.put(:you, your_structure) |> Map.put(:enemy, enemy_structure)
  # end

  # defp define_players(playing_struct, :player2) do
  #   your_structure = Map.put(playing_struct.you, :player, :player2)
  #   enemy_structure = Map.put(playing_struct.enemy, :player, :player1)

  #   playing_struct |> Map.put(:you, your_structure) |> Map.put(:enemy, enemy_structure)
  # end

  defp check_colision(position, players) do
    case check_have_piece(position, players.you) do
      nil -> check_have_piece(position, players.enemy)
      piece -> {"your_piece", piece}
    end
  end

  defp check_have_piece(position, %{alive_pieces: alive_pieces}) do
    result =
      for piece <- alive_pieces do
        have_piece?(position, piece)
      end

    result
    |> Enum.filter(&(!is_nil(&1)))
    |> List.first()
  end

  defp have_piece?(position, piece) when position === piece.position, do: piece
  defp have_piece?(_position, _piece), do: nil

  defp select_piece(nil, socket) do
    settings = %{socket.assigns.settings | cell_selected: nil}
    {:noreply, assign(socket, settings: settings, info: "Your turn!")}
  end

  defp select_piece(%{id: id, type: type, position: position}, socket) do
    settings = %{socket.assigns.settings | cell_selected: position, piece_selected: id}
    {:noreply, assign(socket, settings: settings, info: "Move your #{type}!")}
  end

  defp make_move(
         nil,
         new_position,
         %{alive_pieces: alive_pieces} = _you,
         %{assigns: %{mode: :playing}} = socket
       ) do
    piece_moved = Enum.find(alive_pieces, fn map -> map.id == socket.assigns.settings.piece_selected end)
    |> Map.replace(:position, new_position)



    updated_pieces = [piece_moved | alive_pieces]

    players = update_players(socket.assigns.players, updated_pieces, nil)
    settings = %{socket.assigns.settings | cell_selected: nil, piece_selected: nil}
    {:noreply, assign(socket, settings: settings, info: "Waiting...", players: players)}
  end

  defp make_move(
         {owner, piece},
         new_position,
         _your_pieces,
         %{assigns: %{mode: :playing}} = socket
       ) when owner == "your_piece" do
        IO.puts("############################ new_position  #############################")
        IO.inspect(new_position)
        IO.puts("############################ piece  #############################")
        IO.inspect(piece)
    settings = %{socket.assigns.settings | cell_selected: new_position, piece_selected: piece.id}
    {:noreply, assign(socket, settings: settings, info: "Change piece")}
  end

  defp make_move(
    _piece,
    _new_position,
    _your_pieces,
    %{assigns: %{mode: :playing}} = socket
  ) do
  settings = %{socket.assigns.settings | cell_selected: nil, piece_selected: nil}
  {:noreply, assign(socket, settings: settings, info: "Calculating fight...")}
  end

  defp update_players(players, your_pieces, nil) do
    update_your_pieces = Map.put(players.you, :alive_pieces, your_pieces)
    Map.put(players, :you, update_your_pieces)
  end
end

defmodule ChessWeb.GameLive do
  use ChessWeb, :live_view

  @chess_game_topic "chess_game"


  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    if connected?(socket) do
      ChessWeb.Endpoint.subscribe(@chess_game_topic)
    end

    {:ok,
    socket
    |> assign(:game_name, nil)
    |> assign(:chess_game_topic_id, "chess_game")}
  end

  @impl Phoenix.LiveView
  @spec handle_params(%{:game_name => binary()}, any, map) :: {:noreply, map}
  def handle_params(%{"game_name" => game_name}, _uri, socket) do
    {
      :noreply,
      socket
      |> assign(:game_name, game_name)
    }
  end

  defp handle_rating_created(
        %{assigns: %{pieces: pieces}} = socket,
        updated_position,
        piece_index
      ) do
    Endpoint.broadcast(@chess_game_topic, "pieces", %{}) # I'm new!
    socket
    |> put_flash(:info, "Movement submitted successfully")
    |> assign(
    :pieces,
    List.replace_at(pieces, piece_index, updated_position)
    )
  end
end

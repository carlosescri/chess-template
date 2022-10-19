defmodule ChessWeb.Games.GameLive do
  use Phoenix.LiveView, layout: {ChessWeb.LayoutView, "game_live.html"}
  alias Chess.Games.ChessgameServer

  @white_pieces [
    %{name: "pawn-w1", square: "A2"},
    %{name: "pawn-w2", square: "B2"},
    %{name: "pawn-w3", square: "C2"},
    %{name: "pawn-w4", square: "D2"},
    %{name: "pawn-w5", square: "E2"},
    %{name: "pawn-w6", square: "F2"},
    %{name: "pawn-w7", square: "G2"},
    %{name: "pawn-w8", square: "H2"},
    %{name: "rook-w1", square: "A1"},
    %{name: "rook-w2", square: "H1"},
    %{name: "bishop-w1", square: "C1"},
    %{name: "bishop-w2", square: "F1"},
    %{name: "knight-w1", square: "B1"},
    %{name: "knight-w2", square: "G1"},
    %{name: "queen-white", square: "D1"},
    %{name: "king-white", square: "E1"}
  ]

  @black_pieces [
    %{name: "pawn-b1", square: "A7"},
    %{name: "pawn-b2", square: "B7"},
    %{name: "pawn-b3", square: "C7"},
    %{name: "pawn-b4", square: "D7"},
    %{name: "pawn-b5", square: "E7"},
    %{name: "pawn-b6", square: "F7"},
    %{name: "pawn-b7", square: "G7"},
    %{name: "pawn-b8", square: "H7"},
    %{name: "rook-b1", square: "A8"},
    %{name: "rook-b2", square: "H8"},
    %{name: "bishop-b1", square: "C8"},
    %{name: "bishop-b2", square: "F8"},
    %{name: "knight-b1", square: "B8"},
    %{name: "knight-b2", square: "G8"},
    %{name: "queen-black", square: "D8"},
    %{name: "king-black", square: "E8"}
  ]


  # @white_squares [
  #   "B1","D1","F1","H1",
  #   "A2","C2","E2","G2",
  #   "B3","D3","F3","H3",
  #   "A4","C4","E4","G4",
  #   "B5","D5","F5","H5",
  #   "A6","C6","E6","G6",
  #   "B7","D7","F7","H7",
  #   "A8","C8","E8","G8"
  # ]

  # @black_squeares [
  #   "A1","C1","E1","G1",
  #   "B2","D2","F2","H2",
  #   "A3","C3","E3","G3",
  #   "B4","D4","F4","H4",
  #   "A5","C5","E5","G5",
  #   "B6","D6","F6","H6",
  #   "A7","C7","E7","G7",
  #   "B8","D8","F8","H8"
  # ]

  def render(assigns) do
    ~H"""
<section class="container">
<span>GAME: <%= @game_name %></span>
<table>
    <th><span>Score white:</span></th>
    <th></th>
    <th><span >Score black:</span></th>
    <th><span >Now Moving:</span></th>
    <th><span >Movement:</span></th>
    <tr>
      <td><%= @score_white %></td>
      <td></td>
      <td><%= @score_black %></td>
      <td><%= @turn %></td>
      <td><span><%= @piece %></span>&nbsp;&nbsp;<span><%=@square%></span></td>
    </tr>
</table>
</section>
<section>
  <div class="board">
    <div class="square white" phx-click="square_click" phx-value-square="A8">
      <div class="figure black rook" phx-click="black_click" phx-value-piece="rook-b1"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="B8">
      <div class="figure black knight" phx-click="black_click" phx-value-piece="knight-b1"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="C8">
      <div class="figure black bishop" phx-click="black_click" phx-value-piece="bishop-b1"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="D8">
      <div class="figure black queen" phx-click="black_click" phx-value-piece="queen-black"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="E8">
      <div class="figure black king" phx-click="black_click" phx-value-piece="king-black"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="F8">
      <div class="figure black bishop" phx-click="black_click" phx-value-piece="bishop-b2"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="G8">
      <div class="figure black knight" phx-click="black_click" phx-value-piece="knight-b2"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="H8">
      <div class="figure black rook" phx-click="black_click" phx-value-piece="rook-b2"></div>
    </div>

    <div class="square black" phx-click="square_click" phx-value-square="A7">
      <div class="figure black pawn" phx-click="black_click" phx-value-piece="pawn-b1"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="B7">
      <div class="figure black pawn" phx-click="black_click" phx-value-piece="pawn-b2"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="C7">
      <div class="figure black pawn" phx-click="black_click" phx-value-piece="pawn-b3"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="D7">
      <div class="figure black pawn" phx-click="black_click" phx-value-piece="pawn-b4"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="E7">
      <div class="figure black pawn" phx-click="black_click" phx-value-piece="pawn-b5"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="F7">
      <div class="figure black pawn" phx-click="black_click" phx-value-piece="pawn-b6"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="G7">
      <div class="figure black pawn" phx-click="black_click" phx-value-piece="pawn-b7"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="H7">
      <div class="figure black pawn" phx-click="black_click" phx-value-piece="pawn-b8"></div>
    </div>

    <div class="square white" phx-click="square_click" phx-value-square="A6"></div>
    <div class="square black" phx-click="square_click" phx-value-square="B6"></div>
    <div class="square white" phx-click="square_click" phx-value-square="C6"></div>
    <div class="square black" phx-click="square_click" phx-value-square="D6"></div>
    <div class="square white" phx-click="square_click" phx-value-square="E6"></div>
    <div class="square black" phx-click="square_click" phx-value-square="F6"></div>
    <div class="square white" phx-click="square_click" phx-value-square="G6"></div>
    <div class="square black" phx-click="square_click" phx-value-square="H6"></div>

    <div class="square black" phx-click="square_click" phx-value-square="A5"></div>
    <div class="square white" phx-click="square_click" phx-value-square="B5"></div>
    <div class="square black" phx-click="square_click" phx-value-square="C5"></div>
    <div class="square white" phx-click="square_click" phx-value-square="D5"></div>
    <div class="square black" phx-click="square_click" phx-value-square="E5"></div>
    <div class="square white" phx-click="square_click" phx-value-square="F5"></div>
    <div class="square black" phx-click="square_click" phx-value-square="G5"></div>
    <div class="square white" phx-click="square_click" phx-value-square="H5"></div>

    <div class="square white" phx-click="square_click" phx-value-square="A4"></div>
    <div class="square black" phx-click="square_click" phx-value-square="B4"></div>
    <div class="square white" phx-click="square_click" phx-value-square="C4"></div>
    <div class="square black" phx-click="square_click" phx-value-square="D4"></div>
    <div class="square white" phx-click="square_click" phx-value-square="E4"></div>
    <div class="square black" phx-click="square_click" phx-value-square="F4"></div>
    <div class="square white" phx-click="square_click" phx-value-square="G4"></div>
    <div class="square black" phx-click="square_click" phx-value-square="H4"></div>

    <div class="square black" phx-click="square_click" phx-value-square="A3">
      <%= if @piece !== "" and @square == "A3" do %>
        <div class={build_class_name(@turn, @piece)} phx-click={build_event_name(@turn)} phx-value-piece={@piece}></div>
      <% end %>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="B3">
      <%= if @piece !== "" and @square == "B3" do %>
        <div class={build_class_name(@turn, @piece)} phx-click={build_event_name(@turn)} phx-value-piece={@piece}></div>
      <% end %></div>
    <div class="square black" phx-click="square_click" phx-value-square="C3">
    <%= if @piece !== "" and @square == "C3" do %>
        <div class={build_class_name(@turn, @piece)} phx-click={build_event_name(@turn)} phx-value-piece={@piece}></div>
      <% end %></div>
    <div class="square white" phx-click="square_click" phx-value-square="D3">
    <%= if @piece !== "" and @square == "D3" do %>
        <div class={build_class_name(@turn, @piece)} phx-click={build_event_name(@turn)} phx-value-piece={@piece}></div>
      <% end %></div>
    <div class="square black" phx-click="square_click" phx-value-square="E3">
    <%= if @piece !== "" and @square == "E3" do %>
        <div class={build_class_name(@turn, @piece)} phx-click={build_event_name(@turn)} phx-value-piece={@piece}></div>
      <% end %></div>
    <div class="square white" phx-click="square_click" phx-value-square="F3">
    <%= if @piece !== "" and @square == "F3" do %>
        <div class={build_class_name(@turn, @piece)} phx-click={build_event_name(@turn)} phx-value-piece={@piece}></div>
      <% end %></div>
    <div class="square black" phx-click="square_click" phx-value-square="G3">
    <%= if @piece !== "" and @square == "G3" do %>
        <div class={build_class_name(@turn, @piece)} phx-click={build_event_name(@turn)} phx-value-piece={@piece}></div>
      <% end %></div>
    <div class="square white" phx-click="square_click" phx-value-square="H3">
    <%= if @piece !== "" and @square == "H3" do %>
        <div class={build_class_name(@turn, @piece)} phx-click={build_event_name(@turn)} phx-value-piece={@piece}></div>
      <% end %></div>

    <div class="square white" phx-click="square_click" phx-value-square="A2">
      <div class="figure white pawn" phx-click="white_click" phx-value-piece="pawn-w1"></div>
    </div>
    <div class="square black" phx-click="square_click"  phx-value-square="B2">
      <div class="figure white pawn" phx-click="white_click" phx-value-piece="pawn-w2"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="C2">
      <div class="figure white pawn" phx-click="white_click" phx-value-piece="pawn-w3"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="D2">
      <div class="figure white pawn" phx-click="white_click" phx-value-piece="pawn-w4"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="E2">
      <div class="figure white pawn" phx-click="white_click" phx-value-piece="pawn-w5"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="F2">
      <div class="figure white pawn" phx-click="white_click" phx-value-piece="pawn-w6"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="G2">
      <div class="figure white pawn" phx-click="white_click" phx-value-piece="pawn-w7"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="H2">
      <div class="figure white pawn" phx-click="white_click" phx-value-piece="pawn-w8"></div>
    </div>

    <div class="square black" phx-click="square_click" phx-value-square="A1">
      <div class="figure white rook" phx-click="white_click" phx-value-piece="rook-b1"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="B1">
      <div class="figure white knight" phx-click="white_click" phx-value-piece="knight-b1"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="C1">
      <div class="figure white bishop" phx-click="white_click" phx-value-piece="bishop-b1"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="D1">
      <div class="figure white queen" phx-click="white_click" phx-value-piece="queen-white"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="E1">
      <div class="figure white king" phx-click="white_click" phx-value-piece="king-white"></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="F1">
      <div class="figure white bishop" phx-click="white_click" phx-value-piece="bishop-w2"></div>
    </div>
    <div class="square black" phx-click="square_click" phx-value-square="G1">
      <div class="figure white knight" phx-click="white_click" phx-value-piece="knight-w2" ></div>
    </div>
    <div class="square white" phx-click="square_click" phx-value-square="H1">
      <div class="figure white rook" phx-click="white_click" phx-value-piece="rook-w2"></div>
    </div>
  </div>
</section>

    """
  end

  def mount(%{"game_name" => game_name}, _session, socket) do
    socket = assign(socket, game_name: game_name, score_white: 0, score_black: 0, square: nil, turn: "white", piece: nil )

    ChessgameServer.start_link(String.to_atom(game_name))
    {:ok, socket}
  end

  def handle_event("black_click", %{"piece" => piece}, socket) do
    if socket.assigns.turn == "black" do
      piece = "#{piece}"
      # Each piece will have diferent weight
      score_black = socket.assigns.score_black + 100
      {
      :noreply,
      assign(
        socket,
        piece: piece,
        score_black: score_black,
      )}
      else
        {:noreply, socket}
      end
    end

    def handle_event("white_click", %{"piece" => piece}, socket) do
      if socket.assigns.turn == "white" do
        piece = "#{piece}"
        # Each piece will have diferent weight
        score_white = socket.assigns.score_white + 100
        {
        :noreply,
        assign(
          socket,
          piece: piece,
          score_white: score_white,
        )}
      else
        {:noreply, socket}
        end
      end


      def handle_event("white_click", %{"piece" => piece}, socket) do
        if socket.assigns.turn == "white" do
          piece = "#{piece}"
          # Each piece will have diferent weight
          score_white = socket.assigns.score_white + 100
          {
          :noreply,
          assign(
            socket,
            piece: piece,
            score_white: score_white,
          )}
        else
          {:noreply, socket}
          end
        end

      def handle_event("square_click", %{"square" => square}, socket) do
        square = "#{square}"
        if not is_nil(socket.assigns.piece) do
          # Each piece will have diferent weight
          #score_white = socket.assigns.score_white + 100
              square = "#{square}"
              piece = socket.assigns.piece
              turn = togle_turn(socket.assigns.turn, socket.assigns.piece)
              {
              :noreply,
              assign(
                socket,
                piece: piece,
                square: square,
                turn: turn
              )}
              else
                {:noreply, socket}
              end
      end

      defp togle_turn("white", piece), do: "black"
      defp togle_turn("black", piece), do: "white"

      defp togle_turn(turn, piece) when is_nil(piece), do: turn

      defp get_piece_name(piece_name),do: List.first(String.split(piece_name, ~r/((?<!\s)-(?!\s)|\s)/),1)

      defp build_class_name(color, piece), do: "figure #{color} #{get_piece_name(piece)}"

      defp build_event_name(color), do: "#{color}_click"
end

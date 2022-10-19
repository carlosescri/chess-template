defmodule ChessWeb.PlayingStruct do
  @color_player_1 "white"
  @color_player_2 "black"
  defstruct turn: nil,
            you: %{
              alive_pieces: [
                %{id: "pawn1", type: "pawn", position: {6, 0}, color: @color_player_1},
                %{id: "pawn2", type: "pawn", position: {6, 1}, color: @color_player_1},
                %{id: "pawn3", type: "pawn", position: {6, 2}, color: @color_player_1},
                %{id: "pawn4", type: "pawn", position: {6, 3}, color: @color_player_1},
                %{id: "pawn5", type: "pawn", position: {6, 4}, color: @color_player_1},
                %{id: "pawn6", type: "pawn", position: {6, 5}, color: @color_player_1},
                %{id: "pawn7", type: "pawn", position: {6, 6}, color: @color_player_1},
                %{id: "pawn8", type: "pawn", position: {6, 7}, color: @color_player_1},
                %{id: "rook1", type: "rook", position: {7, 0}, color: @color_player_1},
                %{id: "knight1", type: "knight", position: {7, 1}, color: @color_player_1},
                %{id: "bishop1", type: "bishop", position: {7, 2}, color: @color_player_1},
                %{id: "queen", type: "queen", position: {7, 3}, color: @color_player_1},
                %{id: "king", type: "king", position: {7, 4}, color: @color_player_1},
                %{id: "bishop2", type: "bishop", position: {7, 5}, color: @color_player_1},
                %{id: "knight2", type: "knight", position: {7, 6}, color: @color_player_1},
                %{id: "rook2", type: "rook", position: {7, 7}, color: @color_player_1}
              ],
              player: nil
            },
            enemy: %{
              alive_pieces: [
                %{id: "pawn1", type: "pawn", position: {0, 0}, color: @color_player_2},
                %{id: "pawn2", type: "pawn", position: {0, 1}, color: @color_player_2},
                %{id: "pawn3", type: "pawn", position: {0, 2}, color: @color_player_2},
                %{id: "pawn4", type: "pawn", position: {0, 3}, color: @color_player_2},
                %{id: "pawn5", type: "pawn", position: {0, 4}, color: @color_player_2},
                %{id: "pawn6", type: "pawn", position: {0, 5}, color: @color_player_2},
                %{id: "pawn7", type: "pawn", position: {0, 6}, color: @color_player_2},
                %{id: "pawn8", type: "pawn", position: {0, 7}, color: @color_player_2},
                %{id: "rook1", type: "rook", position: {1, 0}, color: @color_player_2},
                %{id: "knight1", type: "knight", position: {1, 1}, color: @color_player_2},
                %{id: "bishop2", type: "bishop", position: {1, 2}, color: @color_player_2},
                %{id: "queen", type: "queen", position: {1, 3}, color: @color_player_2},
                %{id: "king", type: "king", position: {1, 4}, color: @color_player_2},
                %{id: "bishop2", type: "bishop", position: {1, 5}, color: @color_player_2},
                %{id: "knight2", type: "knight", position: {1, 6}, color: @color_player_2},
                %{id: "rook2", type: "rook", position: {1, 7}, color: @color_player_2}
              ],
              player: nil
            }
end

defmodule ChessWeb.SettingStruct do
  defstruct ready: false,
            cell_selected: nil,
            piece_selected: nil
end

defmodule ChessWeb.PiecesStruct do
  defstruct id: nil,
            type: nil,
            position: nil,
            color: nil
end

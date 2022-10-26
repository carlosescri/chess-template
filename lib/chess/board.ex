defmodule Chess.Board do
  alias Chess.Piece

  def initial_status() do
    board = %{
      0 => %{
        0 => %Piece{color: :white, type: "rook"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "rook"}
      },
      1 => %{
        0 => %Piece{color: :white, type: "knight"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "knight"}
      },
      2 => %{
        0 => %Piece{color: :white, type: "bishop"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "bishop"}
      },
      3 => %{
        0 => %Piece{color: :white, type: "king"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "king"}
      },
      4 => %{
        0 => %Piece{color: :white, type: "queen"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "queen"}
      },
      5 => %{
        0 => %Piece{color: :white, type: "bishop"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "bishop"}
      },
      6 => %{
        0 => %Piece{color: :white, type: "knight"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "knight"}
      },
      7 => %{
        0 => %Piece{color: :white, type: "rook"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "rook"}
      }
    }
  end

  def find_piece(board, x, y) do
    board[x][y]
  end

  def move(
        board,
        %{color: color} = piece,
        {origin_x, origin_y} = origin,
        {target_x, target_y} = target,
        turn
      )
      when color == turn do
    if Piece.can_move?(piece, board, origin, target) do
      piece = Map.put(piece, :first_move, false)
      captured_piece = find_piece(board, target_x, target_y)

      if captured_piece != nil && Map.get(captured_piece, :type) == "king" do
        {:match_end, board}
      else
        board =
          board
          |> put_in([origin_x, origin_y], nil)
          |> put_in([target_x, target_y], piece)

        {:ok, board}
      end
    end
  end

  def move(_board, _piece, _origin, _target, _turn) do
    {:error, :not_your_turn}
  end

  def target_out_of_board?({x, y}) when x > 7 or x < 0 or y > 7 or y < 0 do
    true
  end

  def target_out_of_board?(_), do: false
end

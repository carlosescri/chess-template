defmodule Chess.Board do
  alias Chess.Piece

  @board_min_limit 0
  @board_max_limit 7

  def initial_status() do
    board = %{
      0 => generate_first_row_of_pieces(:white),
      1 => generate_second_row_of_pieces(:white),
      2 => add_blank_positions(),
      3 => add_blank_positions(),
      4 => add_blank_positions(),
      5 => add_blank_positions(),
      6 => generate_second_row_of_pieces(:black),
      7 => generate_first_row_of_pieces(:black)
    }

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
        0 => %Piece{color: :white, type: "queen"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "queen"}
      },
      4 => %{
        0 => %Piece{color: :white, type: "king"},
        1 => %Piece{color: :white, type: "pawn"},
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => %Piece{color: :black, type: "pawn"},
        7 => %Piece{color: :black, type: "king"}
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

  def move(board, piece, {origin_x, origin_y} = origin, {target_x, target_y} = target) do
    if Piece.can_move?(piece, board, origin, target) do
      piece = Map.put(piece, :first_move, false)

      board =
        board
        |> put_in([origin_x, origin_y], nil)
        |> put_in([target_x, target_y], piece)

      {:ok, board}
    end
  end

  def target_out_of_board?({x, y}) when x > 7 or x < 0 or y > 7 or y < 0 do
    true
  end

  def target_out_of_board?(_), do: false

  defp generate_first_row_of_pieces(color) do
    %{
      0 => %Piece{color: color, type: "rook"},
      1 => %Piece{color: color, type: "knight"},
      2 => %Piece{color: color, type: "bishop"},
      3 => %Piece{color: color, type: "queen"},
      4 => %Piece{color: color, type: "king"},
      5 => %Piece{color: color, type: "bishop"},
      6 => %Piece{color: color, type: "knight"},
      7 => %Piece{color: color, type: "rook"}
    }
  end

  defp generate_second_row_of_pieces(color) do
    %{
      0 => %Piece{color: color, type: "pawn"},
      1 => %Piece{color: color, type: "pawn"},
      2 => %Piece{color: color, type: "pawn"},
      3 => %Piece{color: color, type: "pawn"},
      4 => %Piece{color: color, type: "pawn"},
      5 => %Piece{color: color, type: "pawn"},
      6 => %Piece{color: color, type: "pawn"},
      7 => %Piece{color: color, type: "pawn"}
    }
  end

  defp add_blank_positions() do
    %{
      0 => nil,
      1 => nil,
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
      7 => nil
    }
  end
end

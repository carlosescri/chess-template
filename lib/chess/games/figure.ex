defmodule Chess.Game.Figure do
  @type figure() :: :pawn | :rook | :knight | :bishop | :queen | :king
  @type color() :: :black | :white

  defstruct color: nil,
            type: nil

  @type t :: %__MODULE__{
          color: color,
          type: figure
        }

  def valid_moves(%__MODULE__{type: :rook}) do
    0..7
    |> Enum.map(&[{&1, 0}, {0, &1}, {&1 * -1, 0}, {0, &1 * -1}])
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.to_list()
  end

  def valid_moves(%__MODULE__{type: :king}) do
    moves = -1..1
    for x <- moves, y <- moves, do: {x, y}
  end

  def valid_moves(%__MODULE__{type: :knight}) do
    moves = [-2, -1, 1, 2]
    for x <- moves, y <- moves, do: {x, y}
  end

  def valid_moves(%__MODULE__{type: :bishop}) do
    0..7
    |> Enum.map(&[{&1, &1}, {&1, -1 * &1}, {-1 * &1, &1}, {-1 * &1, -1 * &1}])
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.to_list()
  end

  def valid_moves(%__MODULE__{type: :queen}) do
    0..7
    |> Enum.map(
      &[
        {&1, 0},
        {0, &1},
        {&1 * -1, 0},
        {0, &1 * -1},
        {&1, &1},
        {&1, -1 * &1},
        {-1 * &1, &1},
        {-1 * &1, -1 * &1}
      ]
    )
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.to_list()
  end

  def valid_moves(%__MODULE__{type: :pawn, color: :white}) do
    [{-1, 0}, {-2, 0}, {-1, -1}, {-1, 1}]
  end

  def valid_moves(%__MODULE__{type: :pawn, color: :black}) do
    [{1, 0}, {2, 0}, {1, -1}, {1, 1}]
  end

  def valid_moves(_), do: []
end

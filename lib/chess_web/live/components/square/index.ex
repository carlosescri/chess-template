defmodule ChessWeb.SquareLiveComponent do

  use ChessWeb, :live_component
  use Phoenix.HTML

  def square( %{id: id, square: %{square_color: square_color, figure: {player, figure_type}} } = assigns) do
    square_color = "square" <> " " <> square_color
    figure = "figure" <> " " <> player <> " " <> figure_type
    ~H"""
      <div class={square_color}>
        <div class={figure} phx-value-cor={id} phx-value-player={player} phx-value-figure={figure_type} phx-click="select"></div>
      </div>
    """
  end

  def square( %{id: id, square: %{square_color: square_color, figure: nil} } = assigns) do
    square_color = "square" <> " " <> square_color
    ~H"""
      <div class={square_color} phx-value-cor={id} phx-click="select"></div>
    """
  end
end

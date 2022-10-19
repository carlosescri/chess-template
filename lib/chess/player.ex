defmodule Chess.Player do
  @types %{
    id: :integer,
    white: :boolean
  }

  defstruct id: nil,
            white: true
end

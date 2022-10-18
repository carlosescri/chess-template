defmodule ChessWeb.GameServer do
  use GenServer

  import Chess.Pieces, only: [get_initial_position: 0]

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
   end

  def init(_pieces) do
    {:ok, get_initial_position()}
  end

  def get_pieces(pid) do
    GenServer.call(pid, :pieces)
  end

  def handle_call(:pieces, _from, pieces) do
    {:reply, pieces, pieces}
  end

  #Client
  def move_piece(pid, square) do
    GenServer.cast(__MODULE__, {:piece_moved, square})
  end

  #Server
  def handle_cast({:piece_moved, square}, pieces) do
    updated_pieces = Map.delete(pieces, square)
    {:noreply, updated_pieces}
  end

end

# {:ok, pid} = ChessWeb.GameServer.start_link(nil)
# ChessWeb.GameServer.get_pieces(pid)

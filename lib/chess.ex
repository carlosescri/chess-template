defmodule Chess do
  @moduledoc """
  Chess keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Chess.GameServer

  def new_game(game_id) do
    case GameServer.start_link(game_id) do
      {:ok, pid} -> {:ok, pid}
      otherwise -> {:error, inspect(otherwise)}
    end
  end
end

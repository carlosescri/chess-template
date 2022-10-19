defmodule ChessWeb.Presence do
  use Phoenix.Presence,
    otp_app: :chess,
    pubsub_server: Chess.PubSub

  alias ChessWeb.Presence

  def trak_game(pid, topic, state) do
    Presence.track(pid, topic, "", state)
  end
end

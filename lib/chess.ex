defmodule Chess do
  @moduledoc """
  Chess keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defguard is_even(value) when is_integer(value) and rem(value, 2) == 0
  defguard is_odd(value) when is_integer(value) and rem(value, 2) != 0
end

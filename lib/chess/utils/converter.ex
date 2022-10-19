defmodule Chess.Utils.Converter do
  @minute 60
  @hour @minute * 60

  def sec_to_str(seconds) when seconds >= @hour do
    h = div(seconds, @hour)

    m =
      seconds
      |> rem(@hour)
      |> div(@minute)
      |> pad_int()

    s =
      seconds
      |> rem(@hour)
      |> rem(@minute)
      |> pad_int()

    "#{h}:#{m}:#{s}"
  end

  def sec_to_str(seconds) do
    m = div(seconds, @minute)

    s =
      seconds
      |> rem(@minute)
      |> pad_int()

    "#{m}:#{s}"
  end

  ###########
  # PRIVATE #
  ###########

  defp pad_int(int, padding \\ 2) do
    int
    |> Integer.to_string()
    |> String.pad_leading(padding, "0")
  end
end

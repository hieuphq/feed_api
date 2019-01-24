defmodule StringHelper do
  @removing_character [" ", "\r", "\n"]
  def nomalize_str(nil), do: nil

  def nomalize_str(str) when is_binary(str) do
    do_nomalize_str(str)
  end

  def do_nomalize_str(str) when is_binary(str) do
    str
    |> String.codepoints()
    |> do_nomalize_str_left()
    |> Enum.reverse()
    |> do_nomalize_str_left()
    |> Enum.reverse()
    |> Enum.join()
  end

  def do_nomalize_str_left([first | tail] = str) when is_list(str) do
    if Enum.any?(@removing_character, fn k -> k == first end) do
      do_nomalize_str_left(tail)
    else
      str
    end
  end
end

defmodule IntegerHelper do
  def safe_to_integer(nil), do: 0
  def safe_to_integer([]), do: 0

  def safe_to_integer(val) do
    case Integer.parse(val) do
      {int_val, _} -> int_val
      _ -> 0
    end
  end
end

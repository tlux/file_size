defmodule FileSize.Utils do
  @moduledoc false

  @spec compare(number, number) :: :lt | :eq | :gt
  def compare(value, other_value) do
    cond do
      value == other_value -> :eq
      value < other_value -> :lt
      value > other_value -> :gt
    end
  end
end

defmodule FileSize.ComparisonUtils do
  @moduledoc false

  alias FileSize.Comparable

  @spec compare_values(number, number) :: Comparable.comparison_result()
  def compare_values(first, second)
  def compare_values(a, b) when a == b, do: 0
  def compare_values(a, b) when a < b, do: -1
  def compare_values(a, b) when a > b, do: 1
end

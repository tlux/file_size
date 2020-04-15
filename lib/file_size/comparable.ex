defprotocol FileSize.Comparable do
  @moduledoc """
  A protocol that allows comparison of two file sizes.
  """

  @doc """
  Compares two file sizes and returns a value indicating whether the first value
  is less than, greater than or equal to the second one. For possible return
  values, see `t:comparison_result/0`.
  """
  @spec compare(t, t) :: :lt | :eq | :gt
  def compare(size, other_size)
end

defprotocol FileSize.Comparable do
  @moduledoc """
  A protocol that allows comparison of two file sizes.
  """

  @typedoc """
  A type that describes the value that is returned as comparison result of two
  file sizes. The value -1 indicates that the first value is less than the
  second one. 1 means thta the first value is greater than the second one. 0
  indicates equality.
  """
  @type comparison_result :: -1 | 0 | 1

  @doc """
  Compares two file sizes and returns a value indicating whether the first value
  is less than, greater than or equal to the second one. For possible return
  values, see `t:comparison_result/0`.
  """
  @spec compare(t, FileSize.t()) :: comparison_result
  def compare(size, other_size)
end

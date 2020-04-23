defprotocol FileSize.Comparable do
  @moduledoc """
  A protocol that allows comparison of two file sizes.
  """

  @doc """
  Compares two file sizes and returns an atom indicating whether the first value
  is less than, greater than or equal to the second one.
  """
  @spec compare(t, t) :: :lt | :eq | :gt
  def compare(size, other_size)
end

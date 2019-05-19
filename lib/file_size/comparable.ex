defprotocol FileSize.Comparable do
  @type comparison_result :: -1 | 0 | 1

  @spec compare(FileSize.t(), FileSize.t()) :: comparison_result
  def compare(size, other_size)
end

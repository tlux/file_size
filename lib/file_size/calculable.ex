defprotocol FileSize.Calculable do
  @spec add(FileSize.t(), FileSize.t()) :: FileSize.t()
  def add(size, other_size)

  @spec subtract(FileSize.t(), FileSize.t()) :: FileSize.t()
  def subtract(size, other_size)
end

defprotocol FileSize.Calculable do
  @doc """
  Adds two file sizes.
  """
  @spec add(t, FileSize.t()) :: FileSize.t()
  def add(size, other_size)

  @doc """
  Subtracts two file sizes.
  """
  @spec subtract(t, FileSize.t()) :: FileSize.t()
  def subtract(size, other_size)
end

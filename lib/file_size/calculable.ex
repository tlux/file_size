defprotocol FileSize.Calculable do
  @moduledoc """
  A protocol that defines calculations that are possible on file sizes.
  """

  @doc """
  Adds two file sizes.

  ## Examples

      iex> FileSize.add(FileSize.new(1, :kb), FileSize.new(2, :kb))
      #FileSize<"3 kB">

      iex> FileSize.add(FileSize.new(1, :b), FileSize.new(4, :bit))
      #FileSize<"12 bit">

      iex> FileSize.add(FileSize.new(4, :bit), FileSize.new(1, :b))
      #FileSize<"12 bit">

      iex> FileSize.add(FileSize.new(4, :mb), FileSize.new(200, :kb))
      #FileSize<"4.2 MB">
  """
  @spec add(t, t) :: t
  def add(size, other_size)

  @doc """
  Subtracts two file sizes.

  ## Examples

      iex> FileSize.subtract(FileSize.new(3, :kb), FileSize.new(1, :kb))
      #FileSize<"2 kB">

      iex> FileSize.subtract(FileSize.new(1, :b), FileSize.new(4, :bit))
      #FileSize<"0.5 B">
  """
  @spec subtract(t, t) :: t
  def subtract(size, other_size)
end

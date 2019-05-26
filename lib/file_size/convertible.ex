defprotocol FileSize.Convertible do
  @moduledoc """
  A protocol that defines functions to convert file sizes to other units.
  """

  @doc """
  Puts the normalized value in the given file size struct, finalizing the struct
  creation.
  """
  @spec new(t, number) :: FileSize.t()
  def new(size, normalized_value)

  @doc """
  Gets the normalized value from the given file size struct.
  """
  @spec normalized_value(t) :: integer
  def normalized_value(size)

  @doc """
  Converts the given file size to a given unit.

  ## Examples

      iex> FileSize.convert(FileSize.new(2, :kb), :b)
      #FileSize<"2000 B">

      iex> FileSize.convert(FileSize.new(2000, :b), :kb)
      #FileSize<"2.0 kB">

      iex> FileSize.convert(FileSize.new(20, :kb), :kbit)
      #FileSize<"160.0 kbit">

      iex> FileSize.convert(FileSize.new(2000, :b), :unknown)
      ** (FileSize.InvalidUnitError) Invalid unit: :unknown
  """
  @spec convert(t, FileSize.unit()) :: FileSize.t()
  def convert(size, to_unit)
end

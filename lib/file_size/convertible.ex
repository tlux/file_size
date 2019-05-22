defprotocol FileSize.Convertible do
  @spec new(t, number) :: FileSize.t()
  def new(size, normalized_value)

  @spec convert(t, FileSize.unit()) :: FileSize.t()
  def convert(size, to_unit)
end

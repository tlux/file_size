defprotocol FileSize.Convertible do
  @spec convert(FileSize.t(), FileSize.unit()) :: FileSize.t()
  def convert(size, to_unit)
end

defprotocol FileSize.Convertible do
  @spec convert(FileSize.t(), FileSize.unit(), atom, atom) :: FileSize.t()
  def convert(size, to_unit, to_type, to_prefix)
end

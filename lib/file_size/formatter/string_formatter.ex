defimpl String.Chars, for: [FileSize.Bit, FileSize.Byte] do
  alias FileSize.Formatter

  def to_string(size) do
    Formatter.format_simple(size)
  end
end

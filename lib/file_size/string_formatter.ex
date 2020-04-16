defimpl String.Chars, for: [FileSize.Bit, FileSize.Byte] do
  def to_string(size) do
    FileSize.Formatter.format_simple(size)
  end
end

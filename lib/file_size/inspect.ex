defimpl Inspect, for: [FileSize.Bit, FileSize.Byte] do
  import Inspect.Algebra

  def inspect(size, opts) do
    str = FileSize.Formatter.format_simple(size)
    concat(["#FileSize<", to_doc(str, opts), ">"])
  end
end

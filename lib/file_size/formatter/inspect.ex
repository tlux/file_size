defimpl Inspect, for: [FileSize.Bit, FileSize.Byte] do
  alias FileSize.Formatter

  import Inspect.Algebra

  def inspect(size, opts) do
    str = Formatter.format_simple(size)
    concat(["#FileSize<", to_doc(str, opts), ">"])
  end
end

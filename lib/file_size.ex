defmodule FileSize do
  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Calculator
  alias FileSize.Comparable
  alias FileSize.Convertible
  alias FileSize.Formatter
  alias FileSize.InvalidUnitError
  alias FileSize.Parser

  @type unit :: Bit.unit() | Byte.unit()
  @type t :: Bit.t() | Byte.t()

  @units_with_prefixes %{
    # Byte
    b: {:byte, nil},
    kb: {:byte, :kilo},
    kib: {:byte, :kibi},
    mb: {:byte, :mega},
    mib: {:byte, :mebi},
    gb: {:byte, :giga},
    gib: {:byte, :gibi},
    tb: {:byte, :tera},
    tib: {:byte, :tebi},
    pb: {:byte, :peta},
    pib: {:byte, :pebi},
    eb: {:byte, :exa},
    eib: {:byte, :exbi},
    zb: {:byte, :zeta},
    zib: {:byte, :zebi},
    yb: {:byte, :yotta},
    yib: {:byte, :yobi},
    # Bit
    bit: {:bit, nil},
    kbit: {:bit, :kilo},
    kibit: {:bit, :kibi},
    mbit: {:bit, :mega},
    mibit: {:bit, :mebi},
    gbit: {:bit, :giga},
    gibit: {:bit, :gibi},
    tbit: {:bit, :tera},
    tibit: {:bit, :tebi},
    pbit: {:bit, :peta},
    pibit: {:bit, :pebi},
    ebit: {:bit, :exa},
    eibit: {:bit, :exbi},
    zbit: {:bit, :zeta},
    zibit: {:bit, :zebi},
    ybit: {:bit, :yotta},
    yibit: {:bit, :yobi}
  }

  @spec config() :: Keyword.t()
  def config do
    Application.get_all_env(:file_size)
  end

  @doc """
  Builds a new file size.
  """
  @spec new(number, unit) :: t
  def new(value, unit \\ :b) do
    case Map.fetch(@units_with_prefixes, unit) do
      {:ok, {type, prefix}} ->
        normalized_value = normalize_value(value, prefix)
        do_new(type, value, unit, normalized_value)

      _ ->
        raise InvalidUnitError, unit: unit
    end
  end

  defp do_new(:byte, value, unit, bytes) do
    %Byte{value: value, unit: unit, bytes: bytes}
  end

  defp do_new(:bit, value, unit, bits) do
    %Bit{value: value, unit: unit, bits: bits}
  end

  defp normalize_value(value, nil), do: value
  defp normalize_value(value, prefix), do: Calculator.normalize(value, prefix)

  @spec from_bytes(integer, unit) :: t
  def from_bytes(bytes, as_unit) do
    bytes |> new(:b) |> convert(as_unit)
  end

  @spec from_bits(integer, unit) :: t
  def from_bits(bits, as_unit) do
    bits |> new(:bit) |> convert(as_unit)
  end

  @spec from_file(Path.t(), unit) :: {:ok, t} | {:error, File.posix()}
  def from_file(path, as_unit \\ :byte) do
    with {:ok, %{size: value}} <- File.stat(path) do
      {:ok, from_bytes(value, as_unit)}
    end
  end

  @spec from_file!(Path.t(), unit) :: t | no_return
  def from_file!(path, as_unit \\ :byte) do
    path
    |> File.stat!()
    |> Map.fetch!(:size)
    |> from_bytes(as_unit)
  end

  @spec convert(t, unit) :: t
  def convert(size, unit), do: Convertible.convert(size, unit)

  # -1: the first file size is smaller than the second one
  # 0: both arguments represent the same file size
  # 1: the first file size is greater than the second one
  @spec compare(t, t) :: Comparable.comparison_result()
  def compare(size, other_size) do
    Comparable.compare(size, other_size)
  end

  # defp do_compare(%{bytes: bytes}, %{bytes: bytes}), do: 0
  # defp do_compare(%{bytes: a}, %{bytes: b}) when a < b, do: -1
  # defp do_compare(%{bytes: a}, %{bytes: b}) when a > b, do: 1

  @spec equals?(t, t) :: boolean
  def equals?(size, other_size) do
    compare(size, other_size) == 0
  end

  @spec add(t, t) :: t
  def add(%{} = size, %{} = other_size) do
    add(size, other_size, size.unit)
  end

  @spec add(t, t, unit) :: t
  def add(%{} = size, %{} = other_size, as_unit) do
    from_bytes(size.bytes + other_size.bytes, as_unit)
  end

  @spec subtract(t, t) :: t
  def subtract(%{} = size, %{} = other_size) do
    subtract(size, other_size, size.unit)
  end

  @spec subtract(t, t, unit) :: t
  def subtract(%{} = size, %{} = other_size, as_unit) do
    from_bytes(size.bytes - other_size.bytes, as_unit)
  end

  @spec parse(any) :: {:ok, t} | :error
  def parse(value), do: Parser.parse(value)

  @spec parse!(any) :: t | no_return
  def parse!(value), do: Parser.parse!(value)

  @spec format(t, Keyword.t()) :: String.t()
  def format(size, opts \\ []), do: Formatter.format(size, opts)
end

defimpl String.Chars, for: [FileSize.Bit, FileSize.Byte] do
  def to_string(size) do
    FileSize.format(size)
  end
end

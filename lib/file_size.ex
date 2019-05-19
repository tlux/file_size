defmodule FileSize do
  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Calculable
  alias FileSize.Calculator
  alias FileSize.Comparable
  alias FileSize.Convertible
  alias FileSize.Formatter
  alias FileSize.Parser
  alias FileSize.Utils

  @type unit :: Bit.unit() | Byte.unit()
  @type t :: Bit.t() | Byte.t()

  @doc """
  Builds a new file size.
  """
  @spec new(number, unit) :: t
  def new(value, unit \\ :b) do
    {type, prefix} = Utils.fetch_unit_info!(unit)
    normalized_value = Calculator.normalize(value, prefix)
    do_new(type, value, unit, normalized_value)
  end

  defp do_new(:byte, value, unit, bytes) do
    %Byte{value: value, unit: unit, bytes: bytes}
  end

  defp do_new(:bit, value, unit, bits) do
    %Bit{value: value, unit: unit, bits: bits}
  end

  @spec from_bytes(integer, unit) :: t
  def from_bytes(bytes, as_unit) do
    bytes |> new(:b) |> convert(as_unit)
  end

  @spec from_bits(integer, unit) :: t
  def from_bits(bits, as_unit) do
    bits |> new(:bit) |> convert(as_unit)
  end

  @spec from_file(Path.t(), unit) :: {:ok, t} | {:error, File.posix()}
  def from_file(path, as_unit \\ :b) do
    with {:ok, %{size: value}} <- File.stat(path) do
      {:ok, from_bytes(value, as_unit)}
    end
  end

  @spec from_file!(Path.t(), unit) :: t | no_return
  def from_file!(path, as_unit \\ :b) do
    path
    |> File.stat!()
    |> Map.fetch!(:size)
    |> from_bytes(as_unit)
  end

  @spec convert(t, unit) :: t | no_return
  def convert(size, to_unit)
  def convert(%{unit: unit} = size, unit), do: size
  def convert(size, to_unit), do: Convertible.convert(size, to_unit)

  # -1: the first file size is smaller than the second one
  # 0: both arguments represent the same file size
  # 1: the first file size is greater than the second one
  @spec compare(t, t) :: Comparable.comparison_result()
  def compare(size, other_size), do: Comparable.compare(size, other_size)

  # defp do_compare(bits, bits), do: 0
  # defp do_compare(a, b) when a < b, do: -1
  # defp do_compare(a, b) when a > b, do: 1

  @spec equals?(t, t) :: boolean
  def equals?(size, other_size) do
    compare(size, other_size) == 0
  end

  @spec add(t, t) :: t
  def add(size, other_size) do
    Calculable.add(size, other_size)
  end

  @spec add(t, t, unit) :: t
  def add(size, other_size, as_unit) do
    Calculable.add(size, other_size, as_unit)
  end

  @spec subtract(t, t) :: t
  def subtract(size, other_size) do
    Calculable.subtract(size, other_size)
  end

  @spec subtract(t, t, unit) :: t
  def subtract(size, other_size, as_unit) do
    Calculable.subtract(size, other_size, as_unit)
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

defmodule FileSize do
  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Calculable
  alias FileSize.Comparable
  alias FileSize.Convertible
  alias FileSize.Formatter
  alias FileSize.Parser
  alias FileSize.Units

  @type iec_unit :: Bit.iec_unit() | Byte.iec_unit()

  @typedoc """
  A type that contains a union of the bit and byte unit types.
  """
  @type si_unit :: Bit.si_unit() | Byte.si_unit()

  @typedoc """
  A type that is a union of the bit and byte unit types.
  """
  @type unit :: iec_unit | si_unit

  @type unit_system :: :iec | :si

  @type unit_symbol :: String.t()

  @typedoc """
  A type that is a union of the bit and byte types.
  """
  @type t :: Bit.t() | Byte.t()

  @doc """
  Gets the configuration.
  """
  @spec config() :: Keyword.t()
  def config do
    Application.get_all_env(:file_size)
  end

  @doc """
  Builds a new file size.
  """
  @spec new(number, unit) :: t | no_return
  def new(value, unit \\ :b) do
    info = Units.unit_info!(unit)
    normalized_value = Units.normalize_value(value, info)

    info.mod
    |> struct(value: value, unit: unit)
    |> Convertible.new(normalized_value)
  end

  @doc """
  Builds a new file size from the given number of bytes and converts it into the
  unit specified by `:as_unit`.
  """
  @spec from_bytes(number, unit) :: t
  def from_bytes(bytes, as_unit) do
    bytes |> new(:b) |> convert(as_unit)
  end

  @doc """
  Builds a new file size from the given number of bits and converts it into the
  unit specified by `:as_unit`.
  """
  @spec from_bits(number, unit) :: t
  def from_bits(bits, as_unit) do
    bits |> new(:bit) |> convert(as_unit)
  end

  @doc """
  Determines the size of the file at the given path.
  """
  @spec from_file(Path.t(), unit) :: {:ok, t} | {:error, File.posix()}
  def from_file(path, as_unit \\ :b) do
    with {:ok, %{size: value}} <- File.stat(path) do
      {:ok, from_bytes(value, as_unit)}
    end
  end

  @doc """
  Determines the size of the file at the given path. Raises when the file could
  not be found.
  """
  @spec from_file!(Path.t(), unit) :: t | no_return
  def from_file!(path, as_unit \\ :b) do
    path
    |> File.stat!()
    |> Map.fetch!(:size)
    |> from_bytes(as_unit)
  end

  @doc """
  Tries to convert the given value into a file size and returns a success tuple
  or error.
  """
  @spec parse(any) :: {:ok, t} | :error
  def parse(value) do
    Parser.parse(value)
  end

  @doc """
  Tries to convert the given value into a file size and returns it when
  successful or raises on error.
  """
  @spec parse!(any) :: t | no_return
  def parse!(value) do
    Parser.parse!(value)
  end

  @spec format(t, Keyword.t()) :: String.t()
  def format(size, opts \\ []) do
    Formatter.format(size, opts)
  end

  @spec convert(t, unit) :: t
  def convert(size, to_unit) do
    Convertible.convert(size, to_unit)
  end

  @spec change_unit_system(t, unit_system) :: t
  def change_unit_system(size, unit_system) do
    convert(size, Units.equivalent_unit_for_system!(size.unit, unit_system))
  end

  # -1: the first file size is smaller than the second one
  # 0: both arguments represent the same file size
  # 1: the first file size is greater than the second one
  @spec compare(t, t) :: Comparable.comparison_result()
  def compare(size, other_size) do
    Comparable.compare(size, other_size)
  end

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
    size |> add(other_size) |> convert(as_unit)
  end

  @spec subtract(t, t) :: t
  def subtract(size, other_size) do
    Calculable.subtract(size, other_size)
  end

  @spec subtract(t, t, unit) :: t
  def subtract(size, other_size, as_unit) do
    size |> subtract(other_size) |> convert(as_unit)
  end
end

defmodule FileSize do
  defstruct [:value, :unit, :bytes]

  alias FileSize.Converter
  alias FileSize.Formatter
  alias FileSize.Parser

  @type unit ::
          :byte
          | :kb
          | :kib
          | :mb
          | :mib
          | :gb
          | :gib
          | :tb
          | :tib
          | :pb
          | :pib
          | :eb
          | :eib
          | :zb
          | :zib
          | :yb
          | :yib

  @type t :: %__MODULE__{value: number, unit: unit, bytes: integer}

  @spec config() :: Keyword.t()
  def config do
    Application.get_all_env(:file_size)
  end

  @spec new(number, unit) :: t
  def new(value, unit \\ :byte) do
    %__MODULE__{
      value: value,
      unit: unit,
      bytes: Converter.bytes_from_unit(value, unit)
    }
  end

  @spec from_bytes(integer, unit) :: t
  def from_bytes(bytes, as_unit) do
    bytes |> new() |> convert(as_unit)
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
  def convert(size, unit)

  def convert(%__MODULE__{unit: unit} = size, unit), do: size

  def convert(%__MODULE__{} = size, unit) do
    %{
      size
      | value: Converter.bytes_to_unit(size.bytes, unit),
        unit: unit
    }
  end

  # -1: the first file size is smaller than the second one
  # 0: both arguments represent the same file size
  # 1: the first file size is greater than the second one
  @spec compare(t, t) :: -1 | 0 | 1
  def compare(size, other_size)
  def compare(%__MODULE__{bytes: bytes}, %__MODULE__{bytes: bytes}), do: 0
  def compare(%__MODULE__{bytes: a}, %__MODULE__{bytes: b}) when a < b, do: -1
  def compare(%__MODULE__{bytes: a}, %__MODULE__{bytes: b}) when a > b, do: 1

  @spec equals?(t, t) :: boolean
  def equals?(size, other_size) do
    compare(size, other_size) == 0
  end

  @spec add(t, t) :: t
  def add(%__MODULE__{} = size, %__MODULE__{} = other_size) do
    add(size, other_size, size.unit)
  end

  @spec add(t, t, unit) :: t
  def add(%__MODULE__{} = size, %__MODULE__{} = other_size, as_unit) do
    from_bytes(size.bytes + other_size.bytes, as_unit)
  end

  @spec subtract(t, t) :: t
  def subtract(%__MODULE__{} = size, %__MODULE__{} = other_size) do
    subtract(size, other_size, size.unit)
  end

  @spec subtract(t, t, unit) :: t
  def subtract(%__MODULE__{} = size, %__MODULE__{} = other_size, as_unit) do
    from_bytes(size.bytes - other_size.bytes, as_unit)
  end

  @spec parse(any) :: {:ok, t} | :error
  def parse(value) do
    Parser.parse(value)
  end

  @spec parse!(any) :: t | no_return
  def parse!(value) do
    Parser.parse!(value)
  end

  @spec format(t, Keyword.t()) :: String.t()
  def format(%__MODULE__{} = size, opts \\ []) do
    Formatter.format(size, opts)
  end

  @spec to_integer(t) :: integer
  def to_integer(%__MODULE__{} = size) do
    size.bytes
  end
end

defimpl String.Chars, for: FileSize do
  def to_string(size) do
    FileSize.format(size)
  end
end

defmodule FileSize.Bit do
  @moduledoc """
  A struct that represents a file size in bits as lowest possible value.
  """

  defstruct [:value, :unit, :bits]

  @typedoc """
  A type defining the available IEC units.
  """
  @type iec_unit ::
          :bit
          | :kibit
          | :mibit
          | :gibit
          | :tibit
          | :pibit
          | :eibit
          | :zibit
          | :yibit

  @typedoc """
  A type defining the available SI units.
  """
  @type si_unit ::
          :bit
          | :kbit
          | :mbit
          | :gbit
          | :tbit
          | :pbit
          | :ebit
          | :zbit
          | :ybit

  @typedoc """
  A union type combining the available IEC and SI units.
  """
  @type unit :: iec_unit | si_unit

  @typedoc """
  The bit type.
  """
  @type t :: %__MODULE__{value: number, unit: unit, bits: integer}
end

defimpl FileSize.Calculable, for: FileSize.Bit do
  alias FileSize.Bit
  alias FileSize.Byte

  def add(size, %Bit{} = other_size) do
    FileSize.from_bits(size.bits + other_size.bits, size.unit)
  end

  def add(size, %Byte{} = other_size) do
    other_size = FileSize.convert(other_size, :bit)

    (size.bits + other_size.bits)
    |> FileSize.new(:bit)
    |> FileSize.convert(other_size.unit)
  end

  def subtract(size, %Bit{} = other_size) do
    FileSize.from_bits(size.bits - other_size.bits, size.unit)
  end

  def subtract(size, %Byte{} = other_size) do
    other_size = FileSize.convert(other_size, :bit)

    (size.bits - other_size.bits)
    |> FileSize.new(:bit)
    |> FileSize.convert(other_size.unit)
  end
end

defimpl FileSize.Comparable, for: FileSize.Bit do
  import FileSize.ComparisonUtils

  def compare(size, other_size) do
    other_size = FileSize.convert(other_size, :bit)
    compare_values(size.bits, other_size.bits)
  end
end

defimpl FileSize.Convertible, for: FileSize.Bit do
  alias FileSize.Byte
  alias FileSize.Units

  def new(size, bits) do
    %{size | bits: bits}
  end

  def normalized_value(size), do: size.bits

  def convert(%{unit: unit} = size, unit), do: size

  def convert(size, to_unit) do
    info = Units.unit_info!(to_unit)

    size.bits
    |> Units.denormalize_value(info)
    |> convert_between_types(info.mod)
    |> FileSize.new(to_unit)
  end

  defp convert_between_types(value, Byte), do: Float.floor(value / 8)
  defp convert_between_types(value, _), do: value
end

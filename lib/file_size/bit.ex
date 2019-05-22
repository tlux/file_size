defmodule FileSize.Bit do
  alias FileSize.Converter

  defstruct [:value, :unit, :unit_system, :unit_prefix, :bits]

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

  @type unit :: si_unit | iec_unit

  @type t :: %__MODULE__{
          value: number,
          unit: unit,
          unit_system: FileSize.unit_system(),
          unit_prefix: FileSize.unit_prefix(),
          bits: number
        }
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
  alias FileSize.Utils

  def compare(size, other_size) do
    other_size = FileSize.convert(other_size, size.unit)
    Utils.compare_values(size.bits, other_size.bits)
  end
end

defimpl FileSize.Convertible, for: FileSize.Bit do
  alias FileSize.Converter
  alias FileSize.Units

  def convert(%{unit: unit} = size, unit), do: size

  def convert(size, to_unit) do
    {to_type, to_prefix} = Units.unit_type_and_prefix!(to_unit)

    size.bits
    |> Converter.denormalize(to_prefix)
    |> convert_for_type(to_type)
    |> FileSize.new(to_unit)
  end

  defp convert_for_type(value, :byte), do: value / 8
  defp convert_for_type(value, _), do: value
end

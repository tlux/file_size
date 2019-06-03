defmodule FileSize.Bit do
  @moduledoc """
  A struct that represents a file size in bits as lowest possible value.
  """

  @behaviour FileSize.Size

  alias FileSize.Units
  alias FileSize.Units.Info, as: UnitInfo

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
  @type t :: %__MODULE__{value: Decimal.t(), unit: unit, bits: integer}

  @impl true
  def new(value, unit \\ :bit)

  def new(value, %UnitInfo{mod: __MODULE__} = unit_info) do
    value = UnitInfo.sanitize_value(unit_info, value)
    bits = UnitInfo.normalize_value(unit_info, value)
    %__MODULE__{value: value, unit: unit_info.name, bits: bits}
  end

  def new(_value, %UnitInfo{name: unit}) do
    raise ArgumentError,
          "Unable to use unit #{inspect(unit)} " <>
            "for type #{inspect(__MODULE__)}"
  end

  def new(value, unit) do
    new(value, Units.fetch!(unit))
  end
end

defimpl FileSize.Calculable, for: FileSize.Bit do
  alias FileSize.Bit
  alias FileSize.Byte

  def add(size, %Bit{} = other_size) do
    FileSize.from_bits(size.bits + other_size.bits, size.unit)
  end

  def add(size, %Byte{} = other_size) do
    other_size = FileSize.convert(other_size, :bit)

    size.bits
    |> Kernel.+(other_size.bits)
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
  alias FileSize.Units.Info, as: UnitInfo

  def normalized_value(size), do: size.bits

  def convert(%{unit: unit} = size, unit), do: size

  def convert(size, to_unit) do
    unit_info = Units.fetch!(to_unit)
    value = UnitInfo.denormalize_value(unit_info, size.bits)

    value
    |> convert_between_types(unit_info.mod)
    |> FileSize.new(to_unit)
  end

  defp convert_between_types(value, Byte), do: Decimal.div(value, 8)
  defp convert_between_types(value, _), do: value
end

defmodule FileSize.Bit do
  @moduledoc """
  A struct that represents a file size in bits as lowest possible value.
  """

  @behaviour FileSize.Size

  alias FileSize.Size
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
  @type t :: %__MODULE__{value: Decimal.t(), unit: unit, bits: Decimal.t()}

  @impl true
  def new(value, unit_or_unit_info \\ :bit) do
    Size.new(__MODULE__, :bits, value, unit_or_unit_info)
  end
end

defimpl FileSize.Calculable, for: FileSize.Bit do
  def add(size, other_size) do
    other_size = FileSize.convert(other_size, :bit)

    size.bits
    |> Decimal.add(other_size.bits)
    |> FileSize.from_bits(size.unit)
  end

  def subtract(size, other_size) do
    other_size = FileSize.convert(other_size, :bit)

    size.bits
    |> Decimal.sub(other_size.bits)
    |> FileSize.from_bits(size.unit)
  end
end

defimpl FileSize.Comparable, for: FileSize.Bit do
  alias FileSize.Utils

  def compare(size, other_size) do
    other_size = FileSize.convert(other_size, :bit)
    Utils.compare_decimals(size.bits, other_size.bits)
  end
end

defimpl FileSize.Convertible, for: FileSize.Bit do
  alias FileSize.Byte
  alias FileSize.Units.Info, as: UnitInfo

  def normalized_value(size), do: size.bits

  def convert(%{unit: unit} = size, %{name: unit}), do: size

  def convert(size, unit_info) do
    value = UnitInfo.denormalize_value(unit_info, size.bits)

    value
    |> convert_between_types(unit_info.mod)
    |> FileSize.new(unit_info)
  end

  defp convert_between_types(value, Byte), do: Decimal.div(value, 8)
  defp convert_between_types(value, _), do: value
end

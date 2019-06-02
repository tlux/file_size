defmodule FileSize.Byte do
  @moduledoc """
  A struct that represents a file size in bytes as lowest possible value, which
  is a chunk of 8 bits each.
  """

  @behaviour FileSize.Size

  alias FileSize.Units
  alias FileSize.Units.Info, as: UnitInfo

  defstruct [:value, :unit, :bytes]

  @typedoc """
  A type defining the available IEC units.
  """
  @type iec_unit ::
          :b
          | :kib
          | :mib
          | :gib
          | :tib
          | :pib
          | :eib
          | :zib
          | :yib

  @typedoc """
  A type defining the available SI units.
  """
  @type si_unit ::
          :b
          | :kb
          | :mb
          | :gb
          | :tb
          | :pb
          | :eb
          | :zb
          | :yb

  @typedoc """
  A union type combining the available IEC and SI units.
  """
  @type unit :: iec_unit | si_unit

  @typedoc """
  The byte type.
  """
  @type t :: %__MODULE__{value: Decimal.t(), unit: unit, bytes: integer}

  @impl true
  def new(value, unit \\ :b)

  def new(value, %UnitInfo{mod: __MODULE__} = unit_info) do
    bytes = UnitInfo.normalize_value(unit_info, value)
    value = UnitInfo.denormalize_value(unit_info, bytes)
    %__MODULE__{value: value, unit: unit_info.name, bytes: bytes}
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

defimpl FileSize.Calculable, for: FileSize.Byte do
  alias FileSize.Bit
  alias FileSize.Byte

  def add(size, %Bit{} = other_size) do
    size = FileSize.convert(size, :bit)
    FileSize.from_bits(size.bits + other_size.bits, other_size.unit)
  end

  def add(size, %Byte{} = other_size) do
    FileSize.from_bytes(size.bytes + other_size.bytes, size.unit)
  end

  def subtract(size, %Bit{} = other_size) do
    size = FileSize.convert(size, :bit)
    FileSize.from_bits(size.bits - other_size.bits, other_size.unit)
  end

  def subtract(size, %Byte{} = other_size) do
    FileSize.from_bytes(size.bytes - other_size.bytes, size.unit)
  end
end

defimpl FileSize.Comparable, for: FileSize.Byte do
  import FileSize.ComparisonUtils

  alias FileSize.Bit

  def compare(size, %Bit{} = other_size) do
    size = FileSize.convert(size, :bit)
    compare_values(size.bits, other_size.bits)
  end

  def compare(size, other_size) do
    compare_values(size.bytes, other_size.bytes)
  end
end

defimpl FileSize.Convertible, for: FileSize.Byte do
  alias FileSize.Bit
  alias FileSize.Units
  alias FileSize.Units.Info, as: UnitInfo

  def normalized_value(size), do: size.bytes

  def convert(%{unit: unit} = size, unit), do: size

  def convert(size, to_unit) do
    unit_info = Units.fetch!(to_unit)
    value = UnitInfo.denormalize_value(unit_info, size.bytes)

    value
    |> convert_between_types(unit_info.mod)
    |> FileSize.new(to_unit)
  end

  defp convert_between_types(value, Bit), do: Decimal.mult(value, 8)
  defp convert_between_types(value, _), do: value
end

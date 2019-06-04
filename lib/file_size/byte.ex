defmodule FileSize.Byte do
  @moduledoc """
  A struct that represents a file size in bytes as lowest possible value, which
  is a chunk of 8 bits each.
  """

  @behaviour FileSize.Size

  alias FileSize.Size
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
  @type t :: %__MODULE__{value: Decimal.t(), unit: unit, bytes: Decimal.t()}

  @impl true
  def new(value, unit_or_unit_info \\ :b) do
    Size.new(__MODULE__, :bytes, value, unit_or_unit_info)
  end
end

defimpl FileSize.Calculable, for: FileSize.Byte do
  alias FileSize.Bit
  alias FileSize.Byte

  def add(size, %Bit{} = other_size) do
    size
    |> FileSize.convert(:bit)
    |> FileSize.add(other_size)
    |> FileSize.convert(other_size.unit)
  end

  def add(size, %Byte{} = other_size) do
    size.bytes
    |> Decimal.add(other_size.bytes)
    |> FileSize.from_bytes(size.unit)
  end

  def subtract(size, %Bit{} = other_size) do
    size
    |> FileSize.convert(:bit)
    |> FileSize.subtract(other_size)
    |> FileSize.convert(size.unit)
  end

  def subtract(size, %Byte{} = other_size) do
    size.bytes
    |> Decimal.sub(other_size.bytes)
    |> FileSize.from_bytes(other_size.unit)
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
  alias FileSize.Units.Info, as: UnitInfo

  def normalized_value(size), do: size.bytes

  def convert(%{unit: unit} = size, %{name: unit}), do: size

  def convert(size, unit_info) do
    value = UnitInfo.denormalize_value(unit_info, size.bytes)

    value
    |> convert_between_types(unit_info.mod)
    |> FileSize.new(unit_info)
  end

  defp convert_between_types(value, Bit), do: Decimal.mult(value, 8)
  defp convert_between_types(value, _), do: value
end

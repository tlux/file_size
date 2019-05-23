defmodule FileSize.Byte do
  @moduledoc """
  A struct that represents a file size in bytes as lowest possible value, which
  is a chunk of 8 bits each.
  """

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
  @type t :: %__MODULE__{value: number, unit: unit, bytes: integer}
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

  def compare(size, other_size) do
    other_size = FileSize.convert(other_size, size.unit)
    compare_values(size.bytes, other_size.bytes)
  end
end

defimpl FileSize.Convertible, for: FileSize.Byte do
  alias FileSize.Bit
  alias FileSize.Units

  def new(size, bytes) do
    %{size | bytes: bytes}
  end

  def convert(%{unit: unit} = size, unit), do: size

  def convert(size, to_unit) do
    info = Units.unit_info!(to_unit)

    size.bytes
    |> Units.denormalize_value(info)
    |> convert_between_types(info.mod)
    |> FileSize.new(to_unit)
  end

  defp convert_between_types(value, Bit), do: value * 8
  defp convert_between_types(value, _), do: value
end

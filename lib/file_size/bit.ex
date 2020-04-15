defmodule FileSize.Bit do
  @moduledoc """
  A struct that represents a file size in bits as lowest possible value.
  """

  use FileSize.Size, normalized_key: :bits, default_unit: :bit

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
  @type t :: %__MODULE__{value: number, unit: unit, bits: number}

  defimpl FileSize.Calculable do
    def add(size, other_size) do
      other_size = FileSize.convert(other_size, :bit)
      FileSize.from_bits(size.bits + other_size.bits)
    end

    def subtract(size, other_size) do
      other_size = FileSize.convert(other_size, :bit)
      FileSize.from_bits(size.bits - other_size.bits)
    end
  end

  defimpl FileSize.Comparable do
    alias FileSize.Utils

    def compare(size, other_size) do
      other_size = FileSize.convert(other_size, :bit)
      Utils.compare(size.bits, other_size.bits)
    end
  end

  defimpl FileSize.Convertible do
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

    defp convert_between_types(value, Byte), do: value / 8
    defp convert_between_types(value, _), do: value
  end
end

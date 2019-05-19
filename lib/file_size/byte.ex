defmodule FileSize.Byte do
  defstruct [:value, :unit, :bytes]

  @type unit ::
          :b
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

  @type t :: %__MODULE__{value: number, unit: unit, bytes: number}
end

defimpl FileSize.Convertible, for: FileSize.Byte do
  alias FileSize.Calculator
  alias FileSize.Utils

  def convert(size, to_unit) do
    {to_type, to_prefix} = Utils.fetch_unit_info!(to_unit)

    size.bytes
    |> Calculator.denormalize(to_prefix)
    |> convert_for_type(to_type)
    |> FileSize.new(to_unit)
  end

  defp convert_for_type(value, :bit), do: value * 8
  defp convert_for_type(value, _), do: value
end

defimpl FileSize.Comparable, for: FileSize.Byte do
  alias FileSize.Utils

  def compare(size, other_size) do
    other_size = FileSize.convert(other_size, size.unit)
    Utils.compare_values(size.bytes, other_size.bytes)
  end
end

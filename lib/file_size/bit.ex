defmodule FileSize.Bit do
  defstruct [:value, :unit, :bits]

  @type unit ::
          :bit
          | :kbit
          | :kibit
          | :mbit
          | :mibit
          | :gbit
          | :gibit
          | :tbit
          | :tibit
          | :pbit
          | :pibit
          | :ebit
          | :eibit
          | :zbit
          | :zibit
          | :ybit
          | :yibit

  @type t :: %__MODULE__{value: number, unit: unit, bits: number}
end

defimpl FileSize.Convertible, for: FileSize.Bit do
  alias FileSize.Calculator
  alias FileSize.Utils

  def convert(size, to_unit) do
    {to_type, to_prefix} = Utils.fetch_unit_info!(to_unit)

    size.bits
    |> Calculator.denormalize(to_prefix)
    |> convert_for_type(to_type)
    |> FileSize.new(to_unit)
  end

  defp convert_for_type(value, :byte), do: value / 8
  defp convert_for_type(value, _), do: value
end

defimpl FileSize.Comparable, for: FileSize.Bit do
  alias FileSize.Utils

  def compare(size, other_size) do
    other_size = FileSize.convert(other_size, size.unit)
    Utils.compare_values(size.bits, other_size.bits)
  end
end

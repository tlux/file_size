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

  @type t :: %__MODULE__{value: number, unit: unit, bits: integer}
end

defimpl FileSize.Convertible, for: FileSize.Bit do
  alias FileSize.Calculator

  def convert(size, to_unit, to_type, to_prefix) do
    size.bits
    |> Calculator.denormalize(to_prefix)
    |> convert_for_type(to_type)
    |> FileSize.new(to_unit)
  end

  defp convert_for_type(value, :byte), do: value / 8
  defp convert_for_type(value, _), do: value
end

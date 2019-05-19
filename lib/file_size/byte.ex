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

  @type t :: %__MODULE__{value: number, unit: unit, bytes: integer}
end

defimpl FileSize.Convertible, for: FileSize.Byte do
  alias FileSize.Calculator

  def convert(size, to_unit, to_type, to_prefix) do
    size.bytes
    |> Calculator.denormalize(to_prefix)
    |> convert_for_type(to_type)
    |> FileSize.new(to_unit)
  end

  defp convert_for_type(value, :bit), do: value * 8
  defp convert_for_type(value, _), do: value
end

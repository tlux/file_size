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

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

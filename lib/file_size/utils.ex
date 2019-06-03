defmodule FileSize.Utils do
  @moduledoc false

  @spec number_to_decimal(number | Decimal.t()) :: Decimal.t()
  def number_to_decimal(%Decimal{} = value), do: value

  def number_to_decimal(value) when is_integer(value) or is_binary(value) do
    Decimal.new(value)
  end

  def number_to_decimal(value) when is_float(value) do
    Decimal.from_float(value)
  end
end

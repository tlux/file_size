defmodule FileSize.Utils do
  @moduledoc false

  alias FileSize.Comparable

  @spec compare_decimals(Decimal.t(), Decimal.t()) ::
          Comparable.comparison_result()
  def compare_decimals(value, other_value) do
    value
    |> Decimal.compare(other_value)
    |> Decimal.to_integer()
  end

  @spec number_to_decimal(FileSize.value()) :: Decimal.t() | no_return
  def number_to_decimal(%Decimal{} = value), do: value

  def number_to_decimal(value) when is_float(value) do
    Decimal.from_float(value)
  end

  def number_to_decimal(value) when is_integer(value) or is_binary(value) do
    Decimal.new(value)
  rescue
    Decimal.Error -> raise_arg_error!(value)
  end

  def number_to_decimal(value) do
    raise_arg_error!(value)
  end

  defp raise_arg_error!(actual_value) do
    raise ArgumentError,
          "Value must be number, Decimal or string " <>
            "(got #{inspect(actual_value)})"
  end
end

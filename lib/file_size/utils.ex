defmodule FileSize.Utils do
  @moduledoc false

  @spec cast_num(number | String.t() | Decimal.t()) :: {:ok, number} | :error
  def cast_num(value) when is_binary(value) do
    case Float.parse(value) do
      {value, ""} -> cast_num(value)
      _ -> :error
    end
  end

  def cast_num(value) when is_number(value), do: {:ok, sanitize_num(value)}

  if Code.ensure_loaded?(Decimal) do
    def cast_num(%Decimal{} = value), do: {:ok, sanitize_num(value)}
  end

  def cast_num(_), do: :error

  @spec cast_num!(number | String.t() | Decimal.t()) :: number | no_return
  def cast_num!(value) do
    case cast_num(value) do
      {:ok, value} ->
        value

      :error ->
        raise ArgumentError,
              "Unable to cast value " <>
                "(expected a number or binary, got #{inspect(value)})"
    end
  end

  @spec sanitize_num(number) :: number
  def sanitize_num(value) when is_float(value) and value == floor(value) do
    trunc(value)
  end

  def sanitize_num(value) when is_number(value), do: value

  if Code.ensure_loaded?(Decimal) do
    def sanitize_num(%Decimal{} = value) do
      value
      |> Decimal.to_float()
      |> sanitize_num()
    end
  end

  @spec compare(number, number) :: :lt | :eq | :gt
  def compare(value, other_value) do
    cond do
      value == other_value -> :eq
      value < other_value -> :lt
      value > other_value -> :gt
    end
  end
end

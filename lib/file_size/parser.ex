defmodule FileSize.Parser do
  @moduledoc false

  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.ParseError
  alias FileSize.Units

  @spec parse(any) :: {:ok, FileSize.t()} | {:error, ParseError.t()}
  def parse(value)

  def parse(%struct{} = size) when struct in [Bit, Byte], do: {:ok, size}

  def parse(str) when is_binary(str) do
    with {:ok, value_type, value_str, unit_symbol} <- extract_parts(str),
         {:ok, value} <- parse_value(value_type, value_str),
         {:ok, unit} <- parse_unit(unit_symbol) do
      {:ok, FileSize.new(value, unit)}
    else
      {:error, reason} -> {:error, %ParseError{reason: reason, value: str}}
    end
  end

  def parse(value) do
    {:error, %ParseError{reason: :format, value: value}}
  end

  @spec parse!(any) :: FileSize.t() | no_return
  def parse!(value) do
    case parse(value) do
      {:ok, size} -> size
      {:error, error} -> raise error
    end
  end

  defp extract_parts(str) do
    case Regex.named_captures(
           ~r/\A((?<int_value>\d+)|(?<float_value>\d+.\d+)){1} (?<unit>.+)\z/,
           str
         ) do
      %{"float_value" => "", "int_value" => ""} ->
        {:error, :format}

      %{"float_value" => value_str, "int_value" => "", "unit" => unit_str} ->
        {:ok, :float, value_str, unit_str}

      %{"float_value" => "", "int_value" => value_str, "unit" => unit_str} ->
        {:ok, :int, value_str, unit_str}

      _ ->
        {:error, :format}
    end
  end

  defp parse_value(:float, str) do
    case Float.parse(str) do
      {num, ""} -> {:ok, num}
      _ -> {:error, :value}
    end
  end

  defp parse_value(:int, str) do
    case Integer.parse(str) do
      {num, ""} -> {:ok, num}
      _ -> {:error, :value}
    end
  end

  defp parse_unit(unit_symbol) do
    with :error <- Units.from_symbol(unit_symbol) do
      {:error, :unit}
    end
  end
end

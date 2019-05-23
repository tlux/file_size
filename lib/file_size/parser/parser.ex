defmodule FileSize.Parser do
  @moduledoc """
  A module that provides functions to convert values to file sizes.
  """

  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.ParseError
  alias FileSize.Units

  @doc """
  Converts the given value into a `FileSize.Bit` or `FileSize.Byte`. Returns
  a tuple containing the status and value or error.
  """
  @spec parse(any) :: {:ok, FileSize.t()} | {:error, ParseError.t()}
  def parse(value)

  def parse(%Bit{} = size), do: {:ok, size}

  def parse(%Byte{} = size), do: {:ok, size}

  def parse(str) when is_binary(str) do
    with {:ok, value_type, value_str, unit_str} <- extract_parts(str),
         {:ok, value} <- parse_value(value_type, value_str),
         {:ok, unit} <- parse_unit(unit_str) do
      {:ok, FileSize.new(value, unit)}
    else
      {:error, reason} -> {:error, %ParseError{reason: reason, value: str}}
    end
  end

  def parse(value) do
    {:error, %ParseError{reason: :format, value: value}}
  end

  @doc """
  Converts the given value into a `FileSize.Bit` or `FileSize.Byte`. Returns
  the value on success or raises `FileSize.ParseError` on error.
  """
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

  defp parse_unit(unit_str) do
    with :error <- Units.parse_unit(unit_str) do
      {:error, :unit}
    end
  end
end

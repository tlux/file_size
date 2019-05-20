defmodule FileSize.Parser do
  alias FileSize.Bit
  alias FileSize.Byte

  @spec parse(String.t()) :: {:ok, FileSize.t()} | :error
  def parse(value)

  def parse(%Bit{} = size), do: {:ok, size}

  def parse(%Byte{} = size), do: {:ok, size}

  def parse(value) when is_integer(value) or is_float(value) do
    {:ok, FileSize.new(value)}
  end

  def parse(str) when is_binary(str) do
    case String.split(str, " ", parts: 2, trim: true) do
      [value_str, unit_str] -> do_parse(value_str, unit_str)
      [value_str] -> do_parse(value_str, nil)
      _ -> :error
    end
  end

  def parse(_), do: :error

  defp do_parse(value_str, nil) do
    case Float.parse(value_str) do
      {value, _} -> {:ok, FileSize.new(value)}
      _ -> :error
    end
  end

  defp do_parse(value_str, unit_str) do
    with {value, ""} <- Float.parse(value_str),
         {:ok, unit} <- parse_unit(unit_str) do
      {:ok, FileSize.new(value, unit)}
    else
      _ -> :error
    end
  end

  def parse!(value) do
    case parse(value) do
      {:ok, size} -> size
      :error -> raise ArgumentError, "Invalid value: #{inspect(value)}"
    end
  end

  defp parse_unit(unit_str) do
    unit_str = String.downcase(unit_str)

    # TODO: Verify whether the unit really exists!

    try do
      {:ok, String.to_existing_atom(unit_str)}
    rescue
      ArgumentError -> :error
    end
  end
end

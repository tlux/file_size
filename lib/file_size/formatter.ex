defmodule FileSize.Formatter do
  @moduledoc false

  alias FileSize.Units

  @spec format(FileSize.t(), Keyword.t()) :: String.t()
  def format(size, opts \\ []) do
    {symbols, number_opts} = Keyword.pop(opts, :symbols, %{})
    value = format_number(size.value, number_opts)
    symbol = format_unit(size.unit, symbols)
    "#{value} #{symbol}"
  end

  @spec format_simple(FileSize.t()) :: String.t()
  def format_simple(size) do
    unit_info = Units.fetch!(size.unit)
    "#{size.value} #{unit_info.symbol}"
  end

  defp format_number(value, opts) do
    opts =
      [precision: 0]
      |> Keyword.merge(number_opts_from_config())
      |> Keyword.merge(opts)

    Number.Delimit.number_to_delimited(value, opts)
  end

  defp format_unit(unit, symbols) do
    symbols[unit] || symbol_from_config(unit) || symbol_from_unit_info(unit)
  end

  defp number_opts_from_config do
    Keyword.merge(
      Application.get_env(:number, :delimit, []),
      Keyword.get(FileSize.__config__(), :number_format, [])
    )
  end

  defp symbol_from_config(unit) do
    FileSize.__config__()
    |> Keyword.get(:symbols, %{})
    |> Map.get(unit)
  end

  defp symbol_from_unit_info(unit) do
    unit
    |> Units.fetch!()
    |> Map.fetch!(:symbol)
  end
end

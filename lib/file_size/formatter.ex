defmodule FileSize.Formatter do
  alias FileSize.Units

  import Number.Delimit, only: [number_to_delimited: 2]

  @spec format(FileSize.t(), Keyword.t()) :: String.t()
  def format(size, opts \\ []) do
    {symbols, number_opts} = Keyword.pop(opts, :symbols, %{})
    value = format_number(size.value, number_opts)
    symbol = format_unit(size.unit, symbols)
    "#{value} #{symbol}"
  end

  defp format_number(value, opts) do
    opts =
      [precision: 0]
      |> Keyword.merge(number_opts_from_config())
      |> Keyword.merge(opts)

    number_to_delimited(value, opts)
  end

  defp format_unit(unit, symbols) do
    symbols[unit] || symbol_from_config(unit) || symbol_from_unit_info(unit)
  end

  defp number_opts_from_config do
    Keyword.merge(
      Application.get_env(:number, :delimit, []),
      Keyword.get(FileSize.config(), :number_format, [])
    )
  end

  defp symbol_from_config(unit) do
    FileSize.config()
    |> Keyword.get(:symbols, %{})
    |> Map.get(unit)
  end

  defp symbol_from_unit_info(unit) do
    unit
    |> Units.unit_info!()
    |> Map.fetch!(:symbol)
  end
end

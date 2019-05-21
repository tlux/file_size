defmodule FileSize.Formatter do
  alias FileSize.Units
  alias Number.Delimit, as: NumberFormatter

  @spec config() :: Keyword.t()
  def config do
    Keyword.get(FileSize.config(), :formatter, [])
  end

  @spec format(FileSize.t(), Keyword.t()) :: String.t()
  def format(size, opts \\ []) do
    opts = Keyword.merge(config(), opts)
    value = format_number(size.value, opts)
    symbol = format_unit(size.unit, opts[:symbols] || %{})
    "#{value} #{symbol}"
  end

  defp format_number(value, opts) do
    number_opts = Keyword.take(opts, [:precision, :delimiter, :separator])
    NumberFormatter.number_to_delimited(value, number_opts)
  end

  defp format_unit(unit, symbols) do
    case Map.fetch(symbols, unit) do
      {:ok, symbol} -> symbol
      :error -> Units.format_unit(unit)
    end
  end
end

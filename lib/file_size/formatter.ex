defmodule FileSize.Formatter do
  alias Number.Delimit, as: NumberFormatter

  @default_opts [
    symbols: %{
      # Bit
      bit: "bit",
      kbit: "kbit",
      kibit: "Kibit",
      mbit: "Mbit",
      mibit: "Mibit",
      gbit: "Gbit",
      gibit: "Gibit",
      tbit: "Tbit",
      tibit: "Tibit",
      pbit: "Pbit",
      pibit: "Pibit",
      ebit: "Ebit",
      eibit: "Eibit",
      zbit: "Zbit",
      zibit: "Zibit",
      ybit: "Ybit",
      yibit: "Yibit",
      # Byte
      b: "B",
      kb: "kB",
      kib: "KiB",
      mb: "MB",
      mib: "MiB",
      gb: "GB",
      gib: "GiB",
      tb: "TB",
      tib: "TiB",
      pb: "PB",
      pib: "PiB",
      eb: "EB",
      eib: "EiB",
      zb: "ZB",
      zib: "ZiB",
      yb: "YB",
      yib: "YiB"
    }
  ]

  @spec config() :: Keyword.t()
  def config do
    opts = Keyword.get(FileSize.config(), :formatter, [])
    Keyword.merge(@default_opts, opts)
  end

  @spec format(FileSize.t(), Keyword.t()) :: String.t()
  def format(size, opts \\ []) do
    opts = Keyword.merge(config(), opts)
    value = format_number(size.value, opts)
    symbol = Map.fetch!(opts[:symbols], size.unit)

    "#{value} #{symbol}"
  end

  defp format_number(value, opts) do
    number_opts = Keyword.take(opts, [:precision, :delimiter, :separator])
    NumberFormatter.number_to_delimited(value, number_opts)
  end
end

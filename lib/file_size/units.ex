defmodule FileSize.Units do
  @moduledoc false

  alias FileSize.Converter
  alias FileSize.InvalidUnitError

  @type unit_symbol :: String.t()

  @units %{
    # Bit
    bit: {{:bit, nil}, "bit"},
    kbit: {{:bit, :kilo}, "kbit"},
    kibit: {{:bit, :kibi}, "Kibit"},
    mbit: {{:bit, :mega}, "Mbit"},
    mibit: {{:bit, :mebi}, "Mibit"},
    gbit: {{:bit, :giga}, "Gbit"},
    gibit: {{:bit, :gibi}, "Gibit"},
    tbit: {{:bit, :tera}, "Tbit"},
    tibit: {{:bit, :tebi}, "Tibit"},
    pbit: {{:bit, :peta}, "Pbit"},
    pibit: {{:bit, :pebi}, "Pibit"},
    ebit: {{:bit, :exa}, "Ebit"},
    eibit: {{:bit, :exbi}, "Eibit"},
    zbit: {{:bit, :zeta}, "Zbit"},
    zibit: {{:bit, :zebi}, "Zibit"},
    ybit: {{:bit, :yotta}, "Ybit"},
    yibit: {{:bit, :yobi}, "Yibit"},
    # Byte
    b: {{:byte, nil}, "B"},
    kb: {{:byte, :kilo}, "kB"},
    kib: {{:byte, :kibi}, "KiB"},
    mb: {{:byte, :mega}, "MB"},
    mib: {{:byte, :mebi}, "MiB"},
    gb: {{:byte, :giga}, "GB"},
    gib: {{:byte, :gibi}, "GiB"},
    tb: {{:byte, :tera}, "TB"},
    tib: {{:byte, :tebi}, "TiB"},
    pb: {{:byte, :peta}, "PB"},
    pib: {{:byte, :pebi}, "PiB"},
    eb: {{:byte, :exa}, "EB"},
    eib: {{:byte, :exbi}, "EiB"},
    zb: {{:byte, :zeta}, "ZB"},
    zib: {{:byte, :zebi}, "ZiB"},
    yb: {{:byte, :yotta}, "YB"},
    yib: {{:byte, :yobi}, "YiB"}
  }

  @units_by_names Map.new(@units, fn {unit, {_, symbol}} ->
                    {symbol, unit}
                  end)

  @spec unit_info!(FileSize.unit()) ::
          {:bit | :byte, nil | FileSize.unit_system(),
           nil | FileSize.unit_prefix()}
  def unit_info!(unit) do
    with {type, prefix} <- unit_type_and_prefix!(unit) do
      {type, Converter.unit_system(prefix), prefix}
    end
  end

  def unit_type_and_prefix!(unit) do
    case Map.fetch(@units, unit) do
      {:ok, {result, _symbol}} ->
        result

      _ ->
        raise InvalidUnitError, unit: unit
    end
  end

  @spec parse_unit(unit_symbol) :: {:ok, FileSize.unit()} | :error
  def parse_unit(symbol) do
    Map.fetch(@units_by_names, symbol)
  end

  @spec format_unit(FileSize.unit()) :: unit_symbol
  def format_unit(unit) do
    case Map.fetch(@units, unit) do
      {:ok, {_info, symbol}} -> symbol
      _ -> raise InvalidUnitError, unit: unit
    end
  end
end

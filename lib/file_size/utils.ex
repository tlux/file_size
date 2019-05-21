defmodule FileSize.Utils do
  @moduledoc false

  alias FileSize.Comparable
  alias FileSize.InvalidUnitError

  @units_with_prefixes %{
    # Bit
    bit: {:bit, nil},
    kbit: {:bit, :kilo},
    kibit: {:bit, :kibi},
    mbit: {:bit, :mega},
    mibit: {:bit, :mebi},
    gbit: {:bit, :giga},
    gibit: {:bit, :gibi},
    tbit: {:bit, :tera},
    tibit: {:bit, :tebi},
    pbit: {:bit, :peta},
    pibit: {:bit, :pebi},
    ebit: {:bit, :exa},
    eibit: {:bit, :exbi},
    zbit: {:bit, :zeta},
    zibit: {:bit, :zebi},
    ybit: {:bit, :yotta},
    yibit: {:bit, :yobi},
    # Byte
    b: {:byte, nil},
    kb: {:byte, :kilo},
    kib: {:byte, :kibi},
    mb: {:byte, :mega},
    mib: {:byte, :mebi},
    gb: {:byte, :giga},
    gib: {:byte, :gibi},
    tb: {:byte, :tera},
    tib: {:byte, :tebi},
    pb: {:byte, :peta},
    pib: {:byte, :pebi},
    eb: {:byte, :exa},
    eib: {:byte, :exbi},
    zb: {:byte, :zeta},
    zib: {:byte, :zebi},
    yb: {:byte, :yotta},
    yib: {:byte, :yobi}
  }

  @spec valid_unit?(FileSize.unit()) :: boolean
  def valid_unit?(unit) do
    Map.has_key?(@units_with_prefixes, unit)
  end

  @spec fetch_unit_info!(FileSize.unit()) :: {atom, nil | atom}
  def fetch_unit_info!(unit) do
    case Map.fetch(@units_with_prefixes, unit) do
      {:ok, info} -> info
      _ -> raise InvalidUnitError, unit: unit
    end
  end

  @spec compare_values(number, number) :: Comparable.comparison_result()
  def compare_values(first, second)
  def compare_values(value, value), do: 0
  def compare_values(a, b) when a < b, do: -1
  def compare_values(a, b) when a > b, do: 1
end

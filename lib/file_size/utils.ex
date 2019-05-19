defmodule FileSize.Utils do
  @moduledoc false

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

  @spec units_with_prefixes() :: %{optional(atom) => {atom, atom}}
  def units_with_prefixes, do: @units_with_prefixes

  def fetch_unit_info!(unit) do
    case Map.fetch(@units_with_prefixes, unit) do
      {:ok, info} -> info
      _ -> raise InvalidUnitError, unit: unit
    end
  end
end

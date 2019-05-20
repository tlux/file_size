defmodule FileSize.Converter do
  @type si_prefix ::
          :kilo | :mega | :giga | :tera | :peta | :exa | :zeta | :yotta
  @type iec_prefix ::
          :kibi | :mebi | :gibi | :tebi | :pebi | :exbi | :zebi | :yobi
  @type prefix :: si_prefix | iec_prefix

  @factors %{iec: 1024, si: 1000}

  @potencies %{
    kilo: {:si, 1},
    kibi: {:iec, 1},
    mega: {:si, 2},
    mebi: {:iec, 2},
    giga: {:si, 3},
    gibi: {:iec, 3},
    tera: {:si, 4},
    tebi: {:iec, 4},
    peta: {:si, 5},
    pebi: {:iec, 5},
    exa: {:si, 6},
    exbi: {:iec, 6},
    zeta: {:si, 7},
    zebi: {:iec, 7},
    yotta: {:si, 8},
    yobi: {:iec, 8}
  }

  @doc """
  Converts the value with the given prefix to the particular base unit value.
  """
  @spec normalize(number, nil | prefix) :: number
  def normalize(value, prefix)

  def normalize(value, nil), do: value

  @doc """
  Converts the base unit value to the value for the given prefix.
  """
  @spec denormalize(number, nil | prefix) :: number
  def denormalize(value, prefix)

  def denormalize(value, nil), do: value

  Enum.each(@potencies, fn {prefix, {type, exp}} ->
    factor = Math.pow(@factors[type], exp)

    def normalize(value, unquote(prefix)) do
      value * unquote(factor)
    end

    def denormalize(value, unquote(prefix)) do
      value / unquote(factor)
    end
  end)
end

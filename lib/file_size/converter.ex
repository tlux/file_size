defmodule FileSize.Converter do
  alias FileSize.InvalidUnitError

  @factors %{binary: 1024, decimal: 1000}

  @potencies %{
    kb: {:decimal, 1},
    kib: {:binary, 1},
    mb: {:decimal, 2},
    mib: {:binary, 2},
    gb: {:decimal, 3},
    gib: {:binary, 3},
    tb: {:decimal, 4},
    tib: {:binary, 4},
    pb: {:decimal, 5},
    pib: {:binary, 5},
    eb: {:decimal, 6},
    eib: {:binary, 6},
    zb: {:decimal, 7},
    zib: {:binary, 7},
    yb: {:decimal, 8},
    yib: {:binary, 8}
  }

  @spec bytes_from_unit(number, FileSize.unit()) :: integer
  def bytes_from_unit(value, :byte), do: value

  Enum.each(@potencies, fn {unit, {type, exp}} ->
    factor = @factors[type] |> :math.pow(exp) |> trunc()

    def bytes_from_unit(value, unquote(unit)), do: value * unquote(factor)
  end)

  def bytes_from_unit(_, unit) do
    raise InvalidUnitError, unit: unit
  end

  @spec bytes_to_unit(integer, FileSize.unit()) :: number
  def bytes_to_unit(value, :byte), do: value

  Enum.each(@potencies, fn {unit, {type, exp}} ->
    factor = @factors[type] |> :math.pow(exp) |> trunc()

    def bytes_to_unit(value, unquote(unit)), do: value / unquote(factor)
  end)

  def bytes_to_unit(_, unit) do
    raise InvalidUnitError, unit: unit
  end
end

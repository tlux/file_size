defmodule FileSize.Units do
  @moduledoc """
  A module to retrieve information about known units.
  """

  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Convertible
  alias FileSize.InvalidUnitError
  alias FileSize.InvalidUnitSystemError
  alias FileSize.Units.Info

  @unit_systems ~w(iec si)a

  @units [
    # Bit
    %Info{name: :bit, mod: Bit, exp: 0, system: nil, symbol: "bit"},
    %Info{name: :kbit, mod: Bit, exp: 1, system: :si, symbol: "kbit"},
    %Info{name: :kibit, mod: Bit, exp: 1, system: :iec, symbol: "Kibit"},
    %Info{name: :mbit, mod: Bit, exp: 2, system: :si, symbol: "Mbit"},
    %Info{name: :mibit, mod: Bit, exp: 2, system: :iec, symbol: "Mibit"},
    %Info{name: :gbit, mod: Bit, exp: 3, system: :si, symbol: "Gbit"},
    %Info{name: :gibit, mod: Bit, exp: 3, system: :iec, symbol: "Gibit"},
    %Info{name: :tbit, mod: Bit, exp: 4, system: :si, symbol: "Tbit"},
    %Info{name: :tibit, mod: Bit, exp: 4, system: :iec, symbol: "Tibit"},
    %Info{name: :pbit, mod: Bit, exp: 5, system: :si, symbol: "Pbit"},
    %Info{name: :pibit, mod: Bit, exp: 5, system: :iec, symbol: "Pibit"},
    %Info{name: :ebit, mod: Bit, exp: 6, system: :si, symbol: "Ebit"},
    %Info{name: :eibit, mod: Bit, exp: 6, system: :iec, symbol: "Eibit"},
    %Info{name: :ebit, mod: Bit, exp: 6, system: :si, symbol: "Ebit"},
    %Info{name: :eibit, mod: Bit, exp: 6, system: :iec, symbol: "Eibit"},
    %Info{name: :zbit, mod: Bit, exp: 7, system: :si, symbol: "Zbit"},
    %Info{name: :zibit, mod: Bit, exp: 7, system: :iec, symbol: "Zibit"},
    %Info{name: :ybit, mod: Bit, exp: 8, system: :si, symbol: "Ybit"},
    %Info{name: :yibit, mod: Bit, exp: 8, system: :iec, symbol: "Yibit"},
    # Byte
    %Info{name: :b, mod: Byte, exp: 0, system: nil, symbol: "B"},
    %Info{name: :kb, mod: Byte, exp: 1, system: :si, symbol: "kB"},
    %Info{name: :kib, mod: Byte, exp: 1, system: :iec, symbol: "KiB"},
    %Info{name: :mb, mod: Byte, exp: 2, system: :si, symbol: "MB"},
    %Info{name: :mib, mod: Byte, exp: 2, system: :iec, symbol: "MiB"},
    %Info{name: :gb, mod: Byte, exp: 3, system: :si, symbol: "GB"},
    %Info{name: :gib, mod: Byte, exp: 3, system: :iec, symbol: "GiB"},
    %Info{name: :tb, mod: Byte, exp: 4, system: :si, symbol: "TB"},
    %Info{name: :tib, mod: Byte, exp: 4, system: :iec, symbol: "TiB"},
    %Info{name: :pb, mod: Byte, exp: 5, system: :si, symbol: "PB"},
    %Info{name: :pib, mod: Byte, exp: 5, system: :iec, symbol: "PiB"},
    %Info{name: :eb, mod: Byte, exp: 6, system: :si, symbol: "EB"},
    %Info{name: :eib, mod: Byte, exp: 6, system: :iec, symbol: "EiB"},
    %Info{name: :zb, mod: Byte, exp: 7, system: :si, symbol: "ZB"},
    %Info{name: :zib, mod: Byte, exp: 7, system: :iec, symbol: "ZiB"},
    %Info{name: :yb, mod: Byte, exp: 8, system: :si, symbol: "YB"},
    %Info{name: :yib, mod: Byte, exp: 8, system: :iec, symbol: "YiB"}
  ]

  @units_by_names Map.new(@units, fn unit -> {unit.name, unit} end)

  @units_by_symbols Map.new(@units, fn unit -> {unit.symbol, unit} end)

  @units_by_mods_and_systems_and_exps Map.new(@units, fn info ->
                                        {{info.mod, info.system, info.exp},
                                         info}
                                      end)

  @doc """
  Gets a list of all defined units.
  """
  @doc since: "2.0.0"
  @spec list() :: [Info.t()]
  def list, do: @units

  @doc """
  Gets unit info for the unit specified by the given name.
  """
  @doc since: "2.0.0"
  @spec fetch(FileSize.unit()) :: {:ok, Info.t()} | :error
  def fetch(unit) do
    Map.fetch(@units_by_names, unit)
  end

  @doc """
  Gets unit info for the unit specified by the given name. Raises when the unit
  with the given name is unknown.
  """
  @doc since: "2.0.0"
  @spec fetch!(FileSize.unit()) :: Info.t() | no_return
  def fetch!(unit) do
    case fetch(unit) do
      {:ok, info} -> info
      :error -> raise InvalidUnitError, unit: unit
    end
  end

  @doc false
  @spec from_symbol(FileSize.unit_symbol()) :: {:ok, Info.t()} | :error
  def from_symbol(symbol) do
    Map.fetch(@units_by_symbols, symbol)
  end

  @doc false
  @spec equivalent_unit_for_system!(
          FileSize.unit() | Info.t(),
          FileSize.unit_system()
        ) :: Info.t() | no_return
  def equivalent_unit_for_system!(unit_or_info, unit_system)

  def equivalent_unit_for_system!(%Info{} = info, unit_system) do
    find_equivalent_unit_for_system(info, unit_system)
  end

  def equivalent_unit_for_system!(unit, unit_system) do
    unit
    |> fetch!()
    |> find_equivalent_unit_for_system(unit_system)
  end

  defp find_equivalent_unit_for_system(%{system: nil} = info, _), do: info

  defp find_equivalent_unit_for_system(
         %{system: unit_system} = info,
         unit_system
       ) do
    info
  end

  defp find_equivalent_unit_for_system(info, unit_system) do
    validate_unit_system!(unit_system)

    Map.fetch!(
      @units_by_mods_and_systems_and_exps,
      {info.mod, unit_system, info.exp}
    )
  end

  @doc false
  @spec appropriate_unit_for_size!(FileSize.t(), nil | FileSize.unit_system()) ::
          Info.t() | no_return
  def appropriate_unit_for_size!(size, unit_system \\ nil) do
    value = Convertible.normalized_value(size)
    %{mod: mod} = orig_info = fetch!(size.unit)
    unit_system = unit_system || orig_info.system || :si
    validate_unit_system!(unit_system)

    Enum.find_value(@units, orig_info, fn
      %{mod: ^mod, system: ^unit_system} = info ->
        if decimal_between?(value, Info.value_range(info)), do: info

      _ ->
        nil
    end)
  end

  defp decimal_between?(value, min..max) do
    Decimal.cmp(value, min) in [:eq, :gt] &&
      Decimal.cmp(value, max) in [:eq, :lt]
  end

  defp validate_unit_system!(unit_system) when unit_system in @unit_systems do
    :ok
  end

  defp validate_unit_system!(unit_system) do
    raise InvalidUnitSystemError, unit_system: unit_system
  end
end

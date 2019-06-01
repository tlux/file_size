defmodule FileSize.Units do
  @moduledoc false

  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Convertible
  alias FileSize.InvalidUnitError
  alias FileSize.InvalidUnitSystemError
  alias FileSize.UnitInfo

  @units [
    # Bit
    %UnitInfo{name: :bit, mod: Bit, exp: 0, system: nil, symbol: "bit"},
    %UnitInfo{name: :kbit, mod: Bit, exp: 1, system: :si, symbol: "kbit"},
    %UnitInfo{name: :kibit, mod: Bit, exp: 1, system: :iec, symbol: "Kibit"},
    %UnitInfo{name: :mbit, mod: Bit, exp: 2, system: :si, symbol: "Mbit"},
    %UnitInfo{name: :mibit, mod: Bit, exp: 2, system: :iec, symbol: "Mibit"},
    %UnitInfo{name: :gbit, mod: Bit, exp: 3, system: :si, symbol: "Gbit"},
    %UnitInfo{name: :gibit, mod: Bit, exp: 3, system: :iec, symbol: "Gibit"},
    %UnitInfo{name: :tbit, mod: Bit, exp: 4, system: :si, symbol: "Tbit"},
    %UnitInfo{name: :tibit, mod: Bit, exp: 4, system: :iec, symbol: "Tibit"},
    %UnitInfo{name: :pbit, mod: Bit, exp: 5, system: :si, symbol: "Pbit"},
    %UnitInfo{name: :pibit, mod: Bit, exp: 5, system: :iec, symbol: "Pibit"},
    %UnitInfo{name: :ebit, mod: Bit, exp: 6, system: :si, symbol: "Ebit"},
    %UnitInfo{name: :eibit, mod: Bit, exp: 6, system: :iec, symbol: "Eibit"},
    %UnitInfo{name: :ebit, mod: Bit, exp: 6, system: :si, symbol: "Ebit"},
    %UnitInfo{name: :eibit, mod: Bit, exp: 6, system: :iec, symbol: "Eibit"},
    %UnitInfo{name: :zbit, mod: Bit, exp: 7, system: :si, symbol: "Zbit"},
    %UnitInfo{name: :zibit, mod: Bit, exp: 7, system: :iec, symbol: "Zibit"},
    %UnitInfo{name: :ybit, mod: Bit, exp: 8, system: :si, symbol: "Ybit"},
    %UnitInfo{name: :yibit, mod: Bit, exp: 8, system: :iec, symbol: "Yibit"},
    # Byte
    %UnitInfo{name: :b, mod: Byte, exp: 0, system: nil, symbol: "B"},
    %UnitInfo{name: :kb, mod: Byte, exp: 1, system: :si, symbol: "kB"},
    %UnitInfo{name: :kib, mod: Byte, exp: 1, system: :iec, symbol: "KiB"},
    %UnitInfo{name: :mb, mod: Byte, exp: 2, system: :si, symbol: "MB"},
    %UnitInfo{name: :mib, mod: Byte, exp: 2, system: :iec, symbol: "MiB"},
    %UnitInfo{name: :gb, mod: Byte, exp: 3, system: :si, symbol: "GB"},
    %UnitInfo{name: :gib, mod: Byte, exp: 3, system: :iec, symbol: "GiB"},
    %UnitInfo{name: :tb, mod: Byte, exp: 4, system: :si, symbol: "TB"},
    %UnitInfo{name: :tib, mod: Byte, exp: 4, system: :iec, symbol: "TiB"},
    %UnitInfo{name: :pb, mod: Byte, exp: 5, system: :si, symbol: "PB"},
    %UnitInfo{name: :pib, mod: Byte, exp: 5, system: :iec, symbol: "PiB"},
    %UnitInfo{name: :eb, mod: Byte, exp: 6, system: :si, symbol: "EB"},
    %UnitInfo{name: :eib, mod: Byte, exp: 6, system: :iec, symbol: "EiB"},
    %UnitInfo{name: :zb, mod: Byte, exp: 7, system: :si, symbol: "ZB"},
    %UnitInfo{name: :zib, mod: Byte, exp: 7, system: :iec, symbol: "ZiB"},
    %UnitInfo{name: :yb, mod: Byte, exp: 8, system: :si, symbol: "YB"},
    %UnitInfo{name: :yib, mod: Byte, exp: 8, system: :iec, symbol: "YiB"}
  ]

  @units_by_names Map.new(@units, fn unit -> {unit.name, unit} end)
  @units_by_symbols Map.new(@units, fn unit -> {unit.symbol, unit} end)

  @unit_names_by_mods_and_systems_and_exps Map.new(@units, fn info ->
                                             {{info.mod, info.system, info.exp},
                                              info.name}
                                           end)

  @spec unit_infos() :: [UnitInfo.t()]
  def unit_infos, do: @units

  @spec unit_info!(FileSize.unit()) :: {:ok, UnitInfo.t()} | :error
  def unit_info(unit) do
    Map.fetch(@units_by_names, unit)
  end

  @spec unit_info!(FileSize.unit()) :: UnitInfo.t() | no_return
  def unit_info!(unit) do
    case unit_info(unit) do
      {:ok, info} -> info
      :error -> raise InvalidUnitError, unit: unit
    end
  end

  @spec equivalent_unit_for_system!(FileSize.unit(), FileSize.unit_system()) ::
          FileSize.unit() | no_return
  def equivalent_unit_for_system!(unit, unit_system)
      when unit_system in [:iec, :si] do
    unit
    |> unit_info!()
    |> find_equivalent_unit_for_system(unit_system)
  end

  def equivalent_unit_for_system!(_unit, unit_system) do
    raise InvalidUnitSystemError, unit_system: unit_system
  end

  defp find_equivalent_unit_for_system(%{system: nil} = info, _), do: info.name

  defp find_equivalent_unit_for_system(info, unit_system) do
    Map.fetch!(
      @unit_names_by_mods_and_systems_and_exps,
      {info.mod, unit_system, info.exp}
    )
  end

  @spec appropriate_unit_for_size(FileSize.t(), nil | FileSize.unit_system()) ::
          FileSize.unit()
  def appropriate_unit_for_size(size, unit_system \\ nil) do
    value = Convertible.normalized_value(size)
    %{mod: mod} = orig_info = unit_info!(size.unit)
    unit_system = unit_system || orig_info.system || :si

    Enum.find_value(@units, orig_info.name, fn
      %{mod: ^mod, system: ^unit_system} = info ->
        value_range = UnitInfo.value_range(info)
        if Enum.member?(value_range, value), do: info.name

      _ ->
        nil
    end)
  end

  @spec parse_unit(FileSize.unit_symbol()) :: {:ok, FileSize.unit()} | :error
  def parse_unit(symbol) do
    with {:ok, info} <- Map.fetch(@units_by_symbols, symbol) do
      {:ok, info.name}
    end
  end

  @spec format_unit!(FileSize.unit()) :: FileSize.unit_symbol()
  def format_unit!(unit) do
    unit |> unit_info!() |> Map.fetch!(:symbol)
  end

  @spec normalize_value(number, UnitInfo.t()) :: integer
  def normalize_value(value, source_info) do
    trunc(value * UnitInfo.get_factor(source_info))
  end

  @spec denormalize_value(number, UnitInfo.t()) :: float
  def denormalize_value(value, target_info) do
    value / UnitInfo.get_factor(target_info)
  end
end

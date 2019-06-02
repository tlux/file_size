defmodule FileSize.Units.Utils do
  @moduledoc false

  alias FileSize.Convertible
  alias FileSize.InvalidUnitSystemError
  alias FileSize.Units
  alias FileSize.Units.Info

  @units_by_symbols Map.new(Units.list(), fn unit -> {unit.symbol, unit} end)

  @unit_names_by_mods_and_systems_and_exps Map.new(Units.list(), fn info ->
                                             {{info.mod, info.system, info.exp},
                                              info.name}
                                           end)

  @spec equivalent_unit_for_system!(FileSize.unit(), FileSize.unit_system()) ::
          FileSize.unit() | no_return
  def equivalent_unit_for_system!(unit, unit_system)
      when unit_system in [:iec, :si] do
    unit
    |> Units.fetch!()
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
    %{mod: mod} = orig_info = Units.fetch!(size.unit)
    unit_system = unit_system || orig_info.system || :si

    Enum.find_value(Units.list(), orig_info.name, fn
      %{mod: ^mod, system: ^unit_system} = info ->
        value_range = Info.value_range(info)
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
    unit
    |> Units.fetch!()
    |> Map.fetch!(:symbol)
  end
end

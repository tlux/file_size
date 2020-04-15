defmodule FileSize.Units do
  @moduledoc """
  A module to retrieve information about known units.
  """

  alias FileSize.Convertible
  alias FileSize.InvalidUnitError
  alias FileSize.InvalidUnitSystemError
  alias FileSize.Units.Info

  @unit_systems :file_size
                |> Application.fetch_env!(:unit_systems)
                |> Map.keys()

  @units :file_size |> Application.fetch_env!(:units) |> Enum.map(&Info.new/1)

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
  def fetch(unit_or_unit_info)
  def fetch(%Info{} = unit), do: {:ok, unit}
  def fetch(unit), do: Map.fetch(@units_by_names, unit)

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
  @spec equivalent_unit_for_system!(FileSize.unit(), FileSize.unit_system()) ::
          Info.t() | no_return
  def equivalent_unit_for_system!(unit_or_info, unit_system)

  def equivalent_unit_for_system!(%Info{} = info, unit_system) do
    validate_unit_system!(unit_system)
    find_equivalent_unit_for_system(info, unit_system)
  end

  def equivalent_unit_for_system!(unit, unit_system) do
    unit
    |> fetch!()
    |> equivalent_unit_for_system!(unit_system)
  end

  defp find_equivalent_unit_for_system(%{system: nil} = info, _), do: info

  defp find_equivalent_unit_for_system(
         %{system: unit_system} = info,
         unit_system
       ) do
    info
  end

  defp find_equivalent_unit_for_system(info, unit_system) do
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
        if decimal_between?(value, info.min_value, info.max_value), do: info

      _ ->
        nil
    end)
  end

  defp decimal_between?(value, min, max) do
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

defmodule FileSize.Size do
  @moduledoc false

  alias FileSize.Units
  alias FileSize.Units.Info, as: UnitInfo
  alias FileSize.Utils

  @callback new(value :: number | Decimal.t()) :: FileSize.t() | no_return

  @callback new(
              value :: number | Decimal.t(),
              unit :: FileSize.unit()
            ) :: FileSize.t() | no_return

  @spec new(module, atom, number | Decimal.t(), FileSize.unit()) ::
          FileSize.t() | no_return
  def new(mod, normalized_key, value, %{mod: mod} = unit_info) do
    value = sanitize_value(value)
    normalized_value = UnitInfo.normalize_value(unit_info, value)

    mod
    |> struct(value: value, unit: unit_info.name)
    |> Map.put(normalized_key, normalized_value)
  end

  def new(mod, _normalized_key, _value, %UnitInfo{name: unit}) do
    raise ArgumentError,
          "Unable to use unit #{inspect(unit)} for type #{inspect(mod)}"
  end

  def new(mod, normalized_key, value, unit) do
    new(mod, normalized_key, value, Units.fetch!(unit))
  end

  defp sanitize_value(value) do
    value
    |> Utils.number_to_decimal()
    |> Decimal.reduce()
  end
end

defmodule FileSize.Size do
  @moduledoc false

  alias __MODULE__
  alias FileSize.Units
  alias FileSize.Units.Info, as: UnitInfo

  @callback new(value :: number | Decimal.t()) :: FileSize.t() | no_return

  @callback new(
              value :: number | Decimal.t(),
              unit :: FileSize.unit()
            ) :: FileSize.t() | no_return

  defmacro __using__(opts) do
    quote do
      @behaviour Size

      defstruct [:value, :unit, unquote(opts[:normalized_key])]

      @impl Size
      def new(
            value,
            symbol_or_unit_or_unit_info \\ unquote(opts[:default_unit])
          ) do
        Size.new(
          __MODULE__,
          unquote(opts[:normalized_key]),
          value,
          symbol_or_unit_or_unit_info
        )
      end
    end
  end

  @spec new(module, atom, number | Decimal.t(), FileSize.unit()) ::
          FileSize.t() | no_return
  def new(mod, normalized_key, value, %{mod: mod} = unit_info) do
    normalized_value = UnitInfo.normalize_value(unit_info, value)

    mod
    |> struct!(value: value, unit: unit_info.name)
    |> Map.put(normalized_key, normalized_value)
  end

  def new(mod, _normalized_key, _value, %UnitInfo{name: unit}) do
    raise ArgumentError,
          "Unable to use unit #{inspect(unit)} for type #{inspect(mod)}"
  end

  def new(mod, normalized_key, value, symbol_or_unit) do
    new(mod, normalized_key, value, Units.fetch!(symbol_or_unit))
  end
end

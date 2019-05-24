defmodule FileSize.UnitInfo do
  @moduledoc false

  defstruct [:name, :mod, :exp, :system, :symbol]

  @bases %{iec: 1024, si: 1000}

  @type t :: %{
          name: FileSize.unit(),
          mod: module,
          exp: non_neg_integer,
          system: nil | FileSize.unit_system(),
          symbol: FileSize.unit_symbol()
        }

  @spec get_factor(t) :: pos_integer
  def get_factor(info)

  def get_factor(%{system: nil}), do: 1

  def get_factor(%{exp: 0}), do: 1

  def get_factor(info) do
    get_factor_by_system_and_exp(info.system, info.exp)
  end

  defp get_factor_by_system_and_exp(system, exp) do
    @bases
    |> Map.fetch!(info.system)
    |> Math.pow(info.exp)
  end

  @spec min_value(t) :: non_neg_integer
  def min_value(%{exp: 0}), do: 0
  def min_value(info), do: get_factor(info)

  @spec max_value(t) :: non_neg_integer
  def max_value(info) do
    get_factor_by_system_and_exp(info.system, info.exp + 1) - 1
  end

  @spec value_range(t) :: Range.t()
  def value_range(info) do
    min_value(info)..max_value(info)
  end
end

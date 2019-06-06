defmodule FileSize.Units.Info do
  @moduledoc """
  A struct that contains information for a particular unit.
  """

  alias FileSize.Utils

  defstruct [:name, :mod, :exp, :system, :symbol]

  @coefs %{iec: 1024, si: 1000}

  @type t :: %__MODULE__{
          name: FileSize.unit(),
          mod: module,
          exp: non_neg_integer,
          system: nil | FileSize.unit_system(),
          symbol: FileSize.unit_symbol()
        }

  @doc false
  @spec get_factor(t) :: pos_integer
  def get_factor(info)

  def get_factor(%{system: nil}), do: 1

  def get_factor(%{exp: 0}), do: 1

  def get_factor(info) do
    get_factor_by_system_and_exp(info.system, info.exp)
  end

  defp get_factor_by_system_and_exp(system, exp) do
    @coefs |> Map.fetch!(system) |> Math.pow(exp)
  end

  @doc """
  Gets the min value of the given unit.
  """
  @spec min_value(t) :: non_neg_integer
  def min_value(unit_info)
  def min_value(%{exp: 0}), do: 0
  def min_value(unit_info), do: get_factor(unit_info)

  @doc """
  Gets the max value of the given unit.
  """
  @spec max_value(t) :: non_neg_integer
  def max_value(unit_info) do
    get_factor_by_system_and_exp(unit_info.system, unit_info.exp + 1) - 1
  end

  @doc """
  Gets a range of min and max values for the given unit.
  """
  @spec value_range(t) :: Range.t()
  def value_range(unit_info) do
    min_value(unit_info)..max_value(unit_info)
  end

  @doc false
  @spec normalize_value(t, Decimal.t() | number) :: Decimal.t()
  def normalize_value(info, denormalized_value) do
    denormalized_value
    |> Utils.number_to_decimal()
    |> Decimal.mult(get_factor(info))
    |> Decimal.reduce()
  end

  @doc false
  @spec denormalize_value(t, Decimal.t() | number) :: Decimal.t()
  def denormalize_value(unit_info, normalized_value) do
    normalized_value
    |> Utils.number_to_decimal()
    |> Decimal.div(get_factor(unit_info))
    |> Decimal.reduce()
  end
end

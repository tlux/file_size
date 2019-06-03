defmodule FileSize.Units.Info do
  @moduledoc """
  A struct that contains information for a particular unit.
  """

  alias FileSize.Utils

  defstruct [:name, :mod, :exp, :system, :symbol]

  @bases %{iec: 1024, si: 1000}

  @type t :: %{
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
    @bases |> Map.fetch!(system) |> Math.pow(exp)
  end

  @doc """
  Gets the min value of the given unit.
  """
  @spec min_value(t) :: non_neg_integer
  def min_value(%{exp: 0}), do: 0
  def min_value(info), do: get_factor(info)

  @doc """
  Gets the max value of the given unit.
  """
  @spec max_value(t) :: non_neg_integer
  def max_value(info) do
    get_factor_by_system_and_exp(info.system, info.exp + 1) - 1
  end

  @doc """
  Gets a range of min and max values for the given unit.
  """
  @spec value_range(t) :: Range.t()
  def value_range(info) do
    min_value(info)..max_value(info)
  end

  @doc false
  @spec normalize_value(t, Decimal.t() | number) :: integer
  def normalize_value(info, denormalized_value) do
    denormalized_value
    |> Utils.number_to_decimal()
    |> Decimal.mult(get_factor(info))
    |> Decimal.reduce()
  end

  @doc false
  @spec denormalize_value(t, Decimal.t() | number) :: Decimal.t()
  def denormalize_value(info, normalized_value) do
    normalized_value
    |> Utils.number_to_decimal()
    |> Decimal.div(get_factor(info))
    |> Decimal.reduce()
  end

  @doc false
  @spec sanitize_value(t, Decimal.t() | number) :: Decimal.t()
  def sanitize_value(%{exp: 0}, value) do
    value
    |> Utils.number_to_decimal()
    |> Decimal.round()
    |> Decimal.reduce()
  end

  def sanitize_value(_unit_info, value) do
    value
    |> Utils.number_to_decimal()
    |> Decimal.reduce()
  end
end

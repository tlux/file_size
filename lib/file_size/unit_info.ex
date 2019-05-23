defmodule FileSize.UnitInfo do
  @moduledoc """
  A reflection struct that contains additional information for a defined unit.
  """

  defstruct [:name, :mod, :exp, :system, :symbol]

  @bases %{iec: 1024, si: 1000}

  @type t :: %{
          name: FileSize.unit(),
          mod: module,
          exp: non_neg_integer,
          system: nil | FileSize.unit_system(),
          symbol: FileSize.unit_symbol()
        }

  @doc """
  Gets the factor based on the unit system and (unit prefix) exponent from the
  given unit info struct.
  """
  @spec get_factor(t) :: pos_integer
  def get_factor(info)

  def get_factor(%{system: nil}), do: 1

  def get_factor(%{exp: 0}), do: 1

  def get_factor(info) do
    @bases
    |> Map.fetch!(info.system)
    |> Math.pow(info.exp)
  end
end

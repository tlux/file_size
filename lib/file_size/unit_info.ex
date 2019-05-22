defmodule FileSize.UnitInfo do
  defstruct [:name, :mod, :exp, :system, :symbol]

  @bases %{iec: 1024, si: 1000}

  @type t :: %{
          name: FileSize.unit(),
          mod: module,
          exp: non_neg_integer,
          system: nil | FileSize.unit_system(),
          symbol: FileSize.unit_symbol()
        }

  @spec get_factor(t) :: number
  def get_factor(info)

  def get_factor(%{system: nil}), do: 1

  def get_factor(%{exp: 0}), do: 1

  def get_factor(info) do
    @bases
    |> Map.fetch!(info.system)
    |> Math.pow(info.exp)
  end
end

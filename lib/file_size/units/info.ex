defmodule FileSize.Units.Info do
  @moduledoc """
  A struct that contains information for a particular unit.
  """

  alias FileSize.Utils

  defstruct [
    :name,
    :mod,
    :exp,
    :system,
    :symbol,
    :coeff,
    :min_value,
    :max_value
  ]

  @type t :: %__MODULE__{
          name: FileSize.unit(),
          mod: module,
          exp: non_neg_integer,
          system: nil | FileSize.unit_system(),
          symbol: FileSize.unit_symbol(),
          coeff: non_neg_integer,
          min_value: non_neg_integer,
          max_value: non_neg_integer
        }

  @coefficients %{si: 1000, iec: 1024}

  @doc false
  @spec new(Keyword.t() | %{optional(atom) => any}) :: t
  def new(opts) do
    info = struct!(__MODULE__, opts)

    %{
      info
      | coeff: get_coeff(info),
        min_value: min_value(info),
        max_value: max_value(info)
    }
  end

  defp get_coeff(info)

  defp get_coeff(%{system: nil}), do: 1

  defp get_coeff(%{exp: 0}), do: 1

  defp get_coeff(info) do
    get_coeff_by_system_and_exp(info.system, info.exp)
  end

  defp get_coeff_by_system_and_exp(system, exp) do
    @coefficients
    |> Map.fetch!(system)
    |> :math.pow(exp)
    |> trunc()
  end

  defp min_value(info)
  defp min_value(%{exp: 0}), do: 0
  defp min_value(info), do: get_coeff(info)

  defp max_value(%{system: nil}), do: 1023

  defp max_value(info) do
    get_coeff_by_system_and_exp(info.system, info.exp + 1) - 1
  end

  @doc false
  @spec normalize_value(t, number) :: number
  def normalize_value(info, denormalized_value) do
    Utils.sanitize_num(denormalized_value * get_coeff(info))
  end

  @doc false
  @spec denormalize_value(t, number) :: float
  def denormalize_value(info, normalized_value) do
    Utils.sanitize_num(normalized_value / get_coeff(info))
  end
end

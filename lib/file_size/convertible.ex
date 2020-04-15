defprotocol FileSize.Convertible do
  @moduledoc """
  A protocol that defines functions to convert file sizes to other units.
  """

  alias FileSize.Units.Info, as: UnitInfo

  @doc """
  Gets the normalized value from the given file size struct.
  """
  @spec normalized_value(t) :: number
  def normalized_value(size)

  @doc """
  Converts the given file size to a given unit.
  """
  @spec convert(t, UnitInfo.t()) :: FileSize.t()
  def convert(size, unit_info)
end

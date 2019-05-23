defmodule FileSize.InvalidUnitError do
  @moduledoc """
  An exception that raises when converting to an unknown unit.
  """

  defexception [:unit]

  @impl true
  def message(exception) do
    "Invalid unit: #{inspect(exception.unit)}"
  end
end

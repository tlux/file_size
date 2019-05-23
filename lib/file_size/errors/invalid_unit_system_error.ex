defmodule FileSize.InvalidUnitSystemError do
  @moduledoc """
  An exception that raises when converting to an unknown unit system.
  """

  defexception [:unit_system]

  @impl true
  def message(exception) do
    "Invalid unit system: #{inspect(exception.unit_system)}"
  end
end

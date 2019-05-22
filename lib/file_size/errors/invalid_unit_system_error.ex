defmodule FileSize.InvalidUnitSystemError do
  defexception [:unit_system]

  @impl true
  def message(exception) do
    "Invalid unit system: #{inspect(exception.unit_system)}"
  end
end

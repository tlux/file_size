defmodule FileSize.InvalidUnitError do
  defexception [:unit]

  @impl true
  def message(exception) do
    "Invalid unit: #{inspect(exception.unit)}"
  end
end

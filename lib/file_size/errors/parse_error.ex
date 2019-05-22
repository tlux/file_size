defmodule FileSize.ParseError do
  defexception [:reason, :value]

  @impl true
  def message(exception) do
    "Unable to parse value: #{inspect(exception.value)} (#{exception.reason})"
  end
end

defmodule FileSize.ParseError do
  @moduledoc """
  An exception that raises when a value could not be parsed into a file size.
  """

  defexception [:reason, :value]

  @type t :: %__MODULE__{
          reason: atom,
          value: any
        }

  @impl true
  def message(exception) do
    "Unable to parse value: #{inspect(exception.value)} (#{exception.reason})"
  end
end

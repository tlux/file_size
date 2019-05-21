defmodule FileSize.Sigil do
  @moduledoc """
  Provides a sigil that you can use as shortcut to define file sizes easily.
  """

  alias FileSize.Parser

  @doc """
  A sigil function that you can use as shortcut to define file sizes easily.

  ## Examples

      iex> ~F(16 kB)
      %FileSize.Byte{value: 16, unit: :kb, bytes: 16000}

      iex> ~F(8 kbit)
      %FileSize.Bit{value: 8, unit: :kbit, bits: 8000}
  """
  @spec sigil_F(String.t(), charlist) :: FileSize.t()
  def sigil_F(str, _modifiers) do
    Parser.parse!(str)
  end
end

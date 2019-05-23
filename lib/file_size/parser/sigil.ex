defmodule FileSize.Sigil do
  @moduledoc """
  Provides a sigil that you can use as shortcut to define file sizes easily.
  """

  alias FileSize.Parser

  @doc """
  A sigil function that you can use as shortcut to define file sizes easily.

  ## Examples

      iex> ~F(16 kB)
      %FileSize.Byte{value: 16.0, unit: :kb, bytes: 16000}

      iex> ~F(8 Mibit)
      %FileSize.Bit{value: 8.0, unit: :mibit, bits: 8388608}
  """
  @spec sigil_F(String.t(), charlist) :: FileSize.t()
  def sigil_F(str, _modifiers) do
    Parser.parse!(str)
  end
end

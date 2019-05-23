defmodule FileSize.Sigil do
  @moduledoc """
  Provides a sigil that you can use as shortcut to define file sizes easily.
  """

  alias FileSize.Parser

  @doc """
  A sigil function that you can use as shortcut to define file sizes easily.

  ## Examples

      iex> ~F(16 kB)
      #FileSize<"16.0 kB">

      iex> ~F(8 Mibit)
      #FileSize<"8.0 Mibit">
  """
  @spec sigil_F(String.t(), charlist) :: FileSize.t()
  def sigil_F(str, _modifiers) do
    Parser.parse!(str)
  end
end

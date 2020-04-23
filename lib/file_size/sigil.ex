defmodule FileSize.Sigil do
  @moduledoc """
  Provides a sigil that you can use as shortcut to define file sizes easily.
  """

  @doc """
  A sigil function that you can use as shortcut to define file sizes easily.

  ## Examples

      iex> ~F(16 kB)
      #FileSize<"16 kB">

      iex> ~F(8.2 Mibit)
      #FileSize<"8.2 Mibit">
  """
  @spec sigil_F(String.t(), charlist) :: FileSize.t()
  def sigil_F(str, _modifiers) do
    FileSize.Parser.parse!(str)
  end
end

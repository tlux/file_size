defmodule FileSize.Sigil do
  alias FileSize.Parser

  @spec sigil_F(String.t(), charlist) :: FileSize.t()
  def sigil_F(str, _modifiers) do
    Parser.parse!(str)
  end
end

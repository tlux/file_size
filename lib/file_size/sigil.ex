defmodule FileSize.Sigil do
  alias FileSize.Parser

  @spec sigil_f(String.t(), charlist) :: FileSize.t()
  def sigil_f(str, _modifiers) do
    Parser.parse!(str)
  end
end

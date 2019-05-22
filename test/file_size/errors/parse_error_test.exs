defmodule FileSize.ParseErrorTest do
  use ExUnit.Case

  alias FileSize.ParseError

  describe "message/1" do
    test "get message" do
      assert Exception.message(%ParseError{
               value: "invalid value",
               reason: :generic
             }) == ~s[Unable to parse value: "invalid value" (generic)]
    end
  end
end

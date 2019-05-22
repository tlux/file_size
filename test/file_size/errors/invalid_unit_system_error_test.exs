defmodule FileSize.InvalidUnitSystemErrorTest do
  use ExUnit.Case

  alias FileSize.InvalidUnitSystemError

  describe "message/1" do
    test "get message" do
      assert Exception.message(%InvalidUnitSystemError{unit_system: :unknown}) ==
               "Invalid unit system: :unknown"
    end
  end
end

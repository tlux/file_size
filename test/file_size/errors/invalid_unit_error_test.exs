defmodule FileSize.InvalidUnitErrorTest do
  use ExUnit.Case

  alias FileSize.InvalidUnitError

  describe "message/1" do
    test "get message" do
      assert Exception.message(%InvalidUnitError{unit: :unknown}) ==
               "Invalid unit: :unknown"
    end
  end
end

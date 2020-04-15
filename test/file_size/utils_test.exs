defmodule FileSize.UtilsTest do
  use ExUnit.Case

  alias FileSize.Utils

  describe "compare/2" do
    test "first less than second" do
      assert Utils.compare(1, 2) == :lt
      assert Utils.compare(1, 1.2) == :lt
    end

    test "first equal to second" do
      assert Utils.compare(1, 1) == :eq
      assert Utils.compare(1, 1.0) == :eq
    end

    test "first greater than second" do
      assert Utils.compare(2, 1) == :gt
      assert Utils.compare(2, 1.2) == :gt
    end
  end
end

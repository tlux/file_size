defmodule FileSize.ComparisonUtilsTest do
  use ExUnit.Case

  alias FileSize.ComparisonUtils

  describe "compare_values/2" do
    test "first less than second" do
      assert ComparisonUtils.compare_values(1, 2) == -1
    end

    test "first equal to second" do
      assert ComparisonUtils.compare_values(1, 1) == 0
    end

    test "first greater than second" do
      assert ComparisonUtils.compare_values(2, 1) == 1
    end
  end
end

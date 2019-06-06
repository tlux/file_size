defmodule FileSize.UtilsTest do
  use ExUnit.Case

  alias FileSize.Utils

  describe "compare_decimals/2" do
    test "first less than second" do
      assert Utils.compare_decimals(Decimal.new(1), Decimal.new(2)) == -1
    end

    test "first equal to second" do
      assert Utils.compare_decimals(Decimal.new(1), Decimal.new(1)) == 0
    end

    test "first greater than second" do
      assert Utils.compare_decimals(Decimal.new(2), Decimal.new(1)) == 1
    end
  end

  describe "number_to_decimal/1" do
    test "keep Decimal" do
      value = Decimal.new("1.23")

      assert Utils.number_to_decimal(value) == value
    end

    test "convert float to Decimal" do
      assert Utils.number_to_decimal(1.23) == Decimal.new("1.23")
    end

    test "convert integer to Decimal" do
      assert Utils.number_to_decimal(2) == Decimal.new(2)
    end

    test "convert string to Decimal" do
      assert Utils.number_to_decimal("1.23") == Decimal.new("1.23")
    end

    test "raise when string invalid" do
      assert_raise ArgumentError,
                   ~s[Value must be number, Decimal or string (got "invalid")],
                   fn ->
                     Utils.number_to_decimal("invalid")
                   end
    end

    test "raise when value invalid" do
      assert_raise ArgumentError,
                   ~s[Value must be number, Decimal or string (got :invalid)],
                   fn ->
                     Utils.number_to_decimal(:invalid)
                   end
    end
  end
end

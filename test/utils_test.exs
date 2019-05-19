defmodule FileSize.UtilsTest do
  use ExUnit.Case

  alias FileSize.InvalidUnitError
  alias FileSize.Utils

  describe "fetch_unit_info!/1" do
    test "success" do
      assert Utils.fetch_unit_info!(:bit) == {:bit, nil}
      assert Utils.fetch_unit_info!(:kbit) == {:bit, :kilo}
      assert Utils.fetch_unit_info!(:kibit) == {:bit, :kibi}
      assert Utils.fetch_unit_info!(:b) == {:byte, nil}
      assert Utils.fetch_unit_info!(:kb) == {:byte, :kilo}
      assert Utils.fetch_unit_info!(:kib) == {:byte, :kibi}
    end

    test "error" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Utils.fetch_unit_info!(:unknown)
      end
    end
  end

  describe "compare_values/2" do
    test "first less than second" do
      assert Utils.compare_values(1, 2) == -1
    end

    test "first equal to second" do
      assert Utils.compare_values(1, 1) == 0
    end

    test "first greater than second" do
      assert Utils.compare_values(2, 1) == 1
    end
  end
end

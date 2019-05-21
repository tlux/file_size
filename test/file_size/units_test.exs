defmodule FileSize.UnitsTest do
  use ExUnit.Case

  alias FileSize.InvalidUnitError
  alias FileSize.Units

  describe "fetch_unit_info!/1" do
    test "success" do
      assert Units.unit_info!(:bit) == {:bit, nil}
      assert Units.unit_info!(:kbit) == {:bit, :kilo}
      assert Units.unit_info!(:kibit) == {:bit, :kibi}
      assert Units.unit_info!(:b) == {:byte, nil}
      assert Units.unit_info!(:kb) == {:byte, :kilo}
      assert Units.unit_info!(:kib) == {:byte, :kibi}
    end

    test "error" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Units.unit_info!(:unknown)
      end
    end
  end
end

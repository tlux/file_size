defmodule FileSize.UnitsTest do
  use ExUnit.Case

  alias FileSize.InvalidUnitError
  alias FileSize.InvalidUnitSystemError
  alias FileSize.UnitInfo
  alias FileSize.Units

  describe "unit_info!/1" do
    test "success" do
      Enum.each(Units.unit_infos(), fn info ->
        assert Units.unit_info!(info.name) == info
      end)
    end

    test "error" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Units.unit_info!(:unknown)
      end
    end
  end

  describe "equivalent_unit_for_system!/2" do
    test "success" do
      assert Units.equivalent_unit_for_system!(:b, :iec) == :b
      assert Units.equivalent_unit_for_system!(:b, :si) == :b
      assert Units.equivalent_unit_for_system!(:bit, :iec) == :bit
      assert Units.equivalent_unit_for_system!(:bit, :si) == :bit

      assert Units.equivalent_unit_for_system!(:kb, :iec) == :kib
      assert Units.equivalent_unit_for_system!(:kib, :si) == :kb
      assert Units.equivalent_unit_for_system!(:kb, :si) == :kb
      assert Units.equivalent_unit_for_system!(:kib, :iec) == :kib

      assert Units.equivalent_unit_for_system!(:kbit, :iec) == :kibit
      assert Units.equivalent_unit_for_system!(:kibit, :si) == :kbit
      assert Units.equivalent_unit_for_system!(:kbit, :si) == :kbit
      assert Units.equivalent_unit_for_system!(:kibit, :iec) == :kibit
    end

    test "error on unknown unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Units.equivalent_unit_for_system!(:unknown, :si)
      end
    end

    test "error on unknown unit system" do
      assert_raise InvalidUnitSystemError,
                   "Invalid unit system: :unknown",
                   fn ->
                     Units.equivalent_unit_for_system!(:kb, :unknown)
                   end
    end
  end

  describe "parse_unit/1" do
    test "success" do
      Enum.each(Units.unit_infos(), fn %{name: name, symbol: symbol} ->
        assert Units.parse_unit(symbol) == {:ok, name}
      end)
    end

    test "error" do
      assert Units.parse_unit("unknown") == :error
    end
  end

  describe "format_unit!/1" do
    test "success" do
      Enum.each(Units.unit_infos(), fn %{name: name, symbol: symbol} ->
        assert Units.format_unit!(name) == symbol
      end)
    end

    test "error" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Units.format_unit!(:unknown)
      end
    end
  end

  describe "normalize_value/2" do
    test "success" do
      Enum.each(Units.unit_infos(), fn info ->
        factor = UnitInfo.get_factor(info)

        assert Units.normalize_value(1, info) == factor
        assert Units.normalize_value(2, info) == 2 * factor

        result = Units.normalize_value(2.2, info)
        assert result == trunc(2.2 * factor)
        assert is_integer(result)
      end)
    end
  end

  describe "denormalize_value/2" do
    test "success" do
      Enum.each(Units.unit_infos(), fn info ->
        factor = UnitInfo.get_factor(info)
        result = Units.denormalize_value(2, info)

        assert result == 2 / factor
        assert is_float(result)
      end)
    end
  end
end

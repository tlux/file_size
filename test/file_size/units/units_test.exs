defmodule FileSize.UnitsTest do
  use ExUnit.Case

  alias FileSize.InvalidUnitError
  alias FileSize.InvalidUnitSystemError
  alias FileSize.Units

  describe "fetch/1" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        assert Units.fetch(info) == {:ok, info}
        assert Units.fetch(info.name) == {:ok, info}
        assert Units.fetch(info.symbol) == {:ok, info}
      end)
    end

    test "error" do
      assert Units.fetch(:unknown) == :error
    end
  end

  describe "fetch!/1" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        assert Units.fetch!(info) == info
        assert Units.fetch!(info.name) == info
        assert Units.fetch!(info.symbol) == info
      end)
    end

    test "error" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Units.fetch!(:unknown)
      end
    end
  end

  describe "from_symbol/1" do
    test "success" do
      Enum.each(Units.list(), fn unit_info ->
        assert Units.from_symbol(unit_info.symbol) == {:ok, unit_info}
      end)
    end

    test "error" do
      assert Units.from_symbol("unknown") == :error
    end
  end

  describe "equivalent_unit_for_system!/2" do
    test "find unit by atom" do
      assert Units.equivalent_unit_for_system!(:b, :iec) == Units.fetch!(:b)
      assert Units.equivalent_unit_for_system!(:b, :si) == Units.fetch!(:b)
      assert Units.equivalent_unit_for_system!(:bit, :iec) == Units.fetch!(:bit)
      assert Units.equivalent_unit_for_system!(:bit, :si) == Units.fetch!(:bit)

      assert Units.equivalent_unit_for_system!(:kb, :iec) == Units.fetch!(:kib)
      assert Units.equivalent_unit_for_system!(:kib, :si) == Units.fetch!(:kb)
      assert Units.equivalent_unit_for_system!(:kb, :si) == Units.fetch!(:kb)
      assert Units.equivalent_unit_for_system!(:kib, :iec) == Units.fetch!(:kib)

      assert Units.equivalent_unit_for_system!(:kbit, :iec) ==
               Units.fetch!(:kibit)

      assert Units.equivalent_unit_for_system!(:kibit, :si) ==
               Units.fetch!(:kbit)

      assert Units.equivalent_unit_for_system!(:kbit, :si) ==
               Units.fetch!(:kbit)

      assert Units.equivalent_unit_for_system!(:kibit, :iec) ==
               Units.fetch!(:kibit)
    end

    test "find unit by FileSize.Units.Info" do
      assert Units.equivalent_unit_for_system!(Units.fetch!(:b), :iec) ==
               Units.fetch!(:b)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:b), :si) ==
               Units.fetch!(:b)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:bit), :iec) ==
               Units.fetch!(:bit)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:bit), :si) ==
               Units.fetch!(:bit)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:kb), :iec) ==
               Units.fetch!(:kib)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:kib), :si) ==
               Units.fetch!(:kb)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:kb), :si) ==
               Units.fetch!(:kb)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:kib), :iec) ==
               Units.fetch!(:kib)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:kbit), :iec) ==
               Units.fetch!(:kibit)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:kibit), :si) ==
               Units.fetch!(:kbit)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:kbit), :si) ==
               Units.fetch!(:kbit)

      assert Units.equivalent_unit_for_system!(Units.fetch!(:kibit), :iec) ==
               Units.fetch!(:kibit)
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
                     Units.equivalent_unit_for_system!(
                       Units.fetch!(:kb),
                       :unknown
                     )
                   end

      assert_raise InvalidUnitSystemError,
                   "Invalid unit system: :unknown",
                   fn ->
                     Units.equivalent_unit_for_system!(:kb, :unknown)
                   end

      assert_raise InvalidUnitSystemError,
                   "Invalid unit system: :unknown",
                   fn ->
                     Units.equivalent_unit_for_system!(:b, :unknown)
                   end
    end
  end

  describe "appropriate_unit_for_size!/1" do
    test "detect kilobytes" do
      assert Units.appropriate_unit_for_size!(FileSize.new(1000, :b)) ==
               Units.fetch!(:kb)

      assert Units.appropriate_unit_for_size!(FileSize.new(1, :kb)) ==
               Units.fetch!(:kb)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :mb)) ==
               Units.fetch!(:kb)
    end

    test "detect kibibytes" do
      assert Units.appropriate_unit_for_size!(FileSize.new(1, :kib)) ==
               Units.fetch!(:kib)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :mib)) ==
               Units.fetch!(:kib)
    end

    test "detect megabytes" do
      assert Units.appropriate_unit_for_size!(FileSize.new(1000, :kb)) ==
               Units.fetch!(:mb)

      assert Units.appropriate_unit_for_size!(FileSize.new(1, :mb)) ==
               Units.fetch!(:mb)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :gb)) ==
               Units.fetch!(:mb)
    end

    test "detect mebibytes" do
      assert Units.appropriate_unit_for_size!(FileSize.new(1024, :kib)) ==
               Units.fetch!(:mib)

      assert Units.appropriate_unit_for_size!(FileSize.new(1, :mib)) ==
               Units.fetch!(:mib)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :gib)) ==
               Units.fetch!(:mib)
    end

    test "detect megabits" do
      assert Units.appropriate_unit_for_size!(FileSize.new(1_000_000, :bit)) ==
               Units.fetch!(:mbit)

      assert Units.appropriate_unit_for_size!(FileSize.new(1000, :kbit)) ==
               Units.fetch!(:mbit)

      assert Units.appropriate_unit_for_size!(FileSize.new(1, :mbit)) ==
               Units.fetch!(:mbit)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :gbit)) ==
               Units.fetch!(:mbit)
    end
  end

  describe "appropriate_unit_for_size!/2" do
    test "detect kilobytes" do
      assert Units.appropriate_unit_for_size!(FileSize.new(1000, :b), :si) ==
               Units.fetch!(:kb)

      assert Units.appropriate_unit_for_size!(FileSize.new(1, :kb), :si) ==
               Units.fetch!(:kb)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :mb), :si) ==
               Units.fetch!(:kb)

      assert Units.appropriate_unit_for_size!(FileSize.new(1, :kib), :si) ==
               Units.fetch!(:kb)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :mib), :si) ==
               Units.fetch!(:kb)
    end

    test "detect kibibytes" do
      assert Units.appropriate_unit_for_size!(FileSize.new(1024, :b), :iec) ==
               Units.fetch!(:kib)

      assert Units.appropriate_unit_for_size!(FileSize.new(2, :kb), :iec) ==
               Units.fetch!(:kib)

      assert Units.appropriate_unit_for_size!(FileSize.new(1, :kib), :iec) ==
               Units.fetch!(:kib)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :mib), :iec) ==
               Units.fetch!(:kib)

      assert Units.appropriate_unit_for_size!(FileSize.new(0.1, :mb), :iec) ==
               Units.fetch!(:kib)
    end

    test "raise on invalid unit" do
      assert_raise InvalidUnitSystemError,
                   "Invalid unit system: :unknown",
                   fn ->
                     Units.appropriate_unit_for_size!(
                       FileSize.new(2000, :b),
                       :unknown
                     )
                   end
    end
  end
end

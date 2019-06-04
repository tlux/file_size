defmodule FileSize.Units.UtilsTest do
  use ExUnit.Case

  alias FileSize.InvalidUnitError
  alias FileSize.InvalidUnitSystemError
  alias FileSize.Units
  alias FileSize.Units.Utils

  describe "equivalent_unit_for_system!/2" do
    test "success" do
      assert Utils.equivalent_unit_for_system!(:b, :iec) == Units.fetch!(:b)
      assert Utils.equivalent_unit_for_system!(:b, :si) == Units.fetch!(:b)
      assert Utils.equivalent_unit_for_system!(:bit, :iec) == Units.fetch!(:bit)
      assert Utils.equivalent_unit_for_system!(:bit, :si) == Units.fetch!(:bit)

      assert Utils.equivalent_unit_for_system!(:kb, :iec) == Units.fetch!(:kib)
      assert Utils.equivalent_unit_for_system!(:kib, :si) == Units.fetch!(:kb)
      assert Utils.equivalent_unit_for_system!(:kb, :si) == Units.fetch!(:kb)
      assert Utils.equivalent_unit_for_system!(:kib, :iec) == Units.fetch!(:kib)

      assert Utils.equivalent_unit_for_system!(:kbit, :iec) ==
               Units.fetch!(:kibit)

      assert Utils.equivalent_unit_for_system!(:kibit, :si) ==
               Units.fetch!(:kbit)

      assert Utils.equivalent_unit_for_system!(:kbit, :si) ==
               Units.fetch!(:kbit)

      assert Utils.equivalent_unit_for_system!(:kibit, :iec) ==
               Units.fetch!(:kibit)
    end

    test "error on unknown unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Utils.equivalent_unit_for_system!(:unknown, :si)
      end
    end

    test "error on unknown unit system" do
      assert_raise InvalidUnitSystemError,
                   "Invalid unit system: :unknown",
                   fn ->
                     Utils.equivalent_unit_for_system!(:kb, :unknown)
                   end

      assert_raise InvalidUnitSystemError,
                   "Invalid unit system: :unknown",
                   fn ->
                     Utils.equivalent_unit_for_system!(:b, :unknown)
                   end
    end
  end

  describe "appropriate_unit_for_size/1" do
    test "detect kilobytes" do
      assert Utils.appropriate_unit_for_size(FileSize.new(1000, :b)) == :kb
      assert Utils.appropriate_unit_for_size(FileSize.new(1, :kb)) == :kb
      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :mb)) == :kb
    end

    test "detect kibibytes" do
      assert Utils.appropriate_unit_for_size(FileSize.new(1, :kib)) == :kib
      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :mib)) == :kib
    end

    test "detect megabytes" do
      assert Utils.appropriate_unit_for_size(FileSize.new(1000, :kb)) == :mb
      assert Utils.appropriate_unit_for_size(FileSize.new(1, :mb)) == :mb
      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :gb)) == :mb
    end

    test "detect mebibytes" do
      assert Utils.appropriate_unit_for_size(FileSize.new(1024, :kib)) == :mib
      assert Utils.appropriate_unit_for_size(FileSize.new(1, :mib)) == :mib
      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :gib)) == :mib
    end

    test "detect megabits" do
      assert Utils.appropriate_unit_for_size(FileSize.new(1_000_000, :bit)) ==
               :mbit

      assert Utils.appropriate_unit_for_size(FileSize.new(1000, :kbit)) == :mbit
      assert Utils.appropriate_unit_for_size(FileSize.new(1, :mbit)) == :mbit
      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :gbit)) == :mbit
    end
  end

  describe "appropriate_unit_for_size/2" do
    test "detect kilobytes" do
      assert Utils.appropriate_unit_for_size(FileSize.new(1000, :b), :si) == :kb
      assert Utils.appropriate_unit_for_size(FileSize.new(1, :kb), :si) == :kb
      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :mb), :si) == :kb
      assert Utils.appropriate_unit_for_size(FileSize.new(1, :kib), :si) == :kb

      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :mib), :si) ==
               :kb
    end

    test "detect kibibytes" do
      assert Utils.appropriate_unit_for_size(FileSize.new(1024, :b), :iec) ==
               :kib

      assert Utils.appropriate_unit_for_size(FileSize.new(2, :kb), :iec) ==
               :kib

      assert Utils.appropriate_unit_for_size(FileSize.new(1, :kib), :iec) ==
               :kib

      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :mib), :iec) ==
               :kib

      assert Utils.appropriate_unit_for_size(FileSize.new(0.1, :mb), :iec) ==
               :kib
    end
  end

  describe "parse_unit/1" do
    test "success" do
      Enum.each(Units.list(), fn %{name: name, symbol: symbol} ->
        assert Utils.parse_unit(symbol) == {:ok, name}
      end)
    end

    test "error" do
      assert Utils.parse_unit("unknown") == :error
    end
  end

  describe "format_unit!/1" do
    test "success" do
      Enum.each(Units.list(), fn %{name: name, symbol: symbol} ->
        assert Utils.format_unit!(name) == symbol
      end)
    end

    test "error" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Utils.format_unit!(:unknown)
      end
    end
  end
end

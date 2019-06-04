defmodule FileSize.BitTest do
  use ExUnit.Case

  alias FileSize.Bit
  alias FileSize.InvalidUnitError
  alias FileSize.Units

  describe "new/1" do
    test "use byte as default unit" do
      assert Bit.new(1) == Bit.new(1, :bit)
    end
  end

  describe "new/2" do
    test "new byte" do
      assert Bit.new(1, :bit) == %Bit{
               value: Decimal.new(1),
               unit: :bit,
               bits: Decimal.new(1)
             }

      assert Bit.new(1.2, :bit) == %Bit{
               value: Decimal.new("1.2"),
               unit: :bit,
               bits: Decimal.new("1.2")
             }

      assert Bit.new(1.6, :bit) == %Bit{
               value: Decimal.new("1.6"),
               unit: :bit,
               bits: Decimal.new("1.6")
             }
    end

    test "new kilobit" do
      assert Bit.new(1, :kbit) == %Bit{
               value: Decimal.new(1),
               unit: :kbit,
               bits: Decimal.new("1E+3")
             }

      assert Bit.new(1.23, :kbit) == %Bit{
               value: Decimal.new("1.23"),
               unit: :kbit,
               bits: Decimal.new("1.23E+3")
             }

      assert Bit.new(1.67, :kbit) == %Bit{
               value: Decimal.new("1.67"),
               unit: :kbit,
               bits: Decimal.new("1.67E+3")
             }
    end

    test "new kibibit" do
      assert Bit.new(1, :kibit) == %Bit{
               value: Decimal.new(1),
               unit: :kibit,
               bits: Decimal.new(1024)
             }

      assert Bit.new(1.23, :kibit) == %Bit{
               value: Decimal.from_float(1.23),
               unit: :kibit,
               bits: Decimal.mult(1024, "1.23")
             }

      assert Bit.new(1.67, :kibit) == %Bit{
               value: Decimal.from_float(1.67),
               unit: :kibit,
               bits: Decimal.mult(1024, "1.67")
             }
    end

    test "with unit as FileSize.Units.Info" do
      Enum.each([:bit, :kbit, :kibit], fn unit ->
        unit_info = Units.fetch!(unit)

        assert Bit.new(1337, unit) == Bit.new(1337, unit_info)
      end)
    end

    test "raise on invalid unit" do
      assert_raise ArgumentError,
                   "Unable to use unit :b for type FileSize.Bit",
                   fn ->
                     Bit.new(1337, :b)
                   end
    end

    test "raise on unknown unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Bit.new(1337, :unknown)
      end
    end
  end
end

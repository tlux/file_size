defmodule FileSize.ByteTest do
  use ExUnit.Case

  alias FileSize.Byte
  alias FileSize.InvalidUnitError
  alias FileSize.Units

  describe "new/1" do
    test "use byte as default unit" do
      assert Byte.new(1) == Byte.new(1, :b)
    end
  end

  describe "new/2" do
    test "new byte" do
      assert Byte.new(1, :b) == %Byte{value: 1, unit: :b, bytes: 1}
      assert Byte.new(1.2, :b) == %Byte{value: 1.2, unit: :b, bytes: 1.2}
      assert Byte.new(1.6, :b) == %Byte{value: 1.6, unit: :b, bytes: 1.6}
      assert Byte.new(1, "B") == %Byte{value: 1, unit: :b, bytes: 1}
      assert Byte.new(1.2, "B") == %Byte{value: 1.2, unit: :b, bytes: 1.2}
      assert Byte.new(1.6, "B") == %Byte{value: 1.6, unit: :b, bytes: 1.6}
    end

    test "new kilobyte" do
      assert Byte.new(1, :kb) == %Byte{value: 1, unit: :kb, bytes: 1000}
      assert Byte.new(1.23, :kb) == %Byte{value: 1.23, unit: :kb, bytes: 1230}
      assert Byte.new(1.67, :kb) == %Byte{value: 1.67, unit: :kb, bytes: 1670}
      assert Byte.new(1, "kB") == %Byte{value: 1, unit: :kb, bytes: 1000}
      assert Byte.new(1.23, "kB") == %Byte{value: 1.23, unit: :kb, bytes: 1230}
      assert Byte.new(1.67, "kB") == %Byte{value: 1.67, unit: :kb, bytes: 1670}
    end

    test "new kibibyte" do
      assert Byte.new(1, :kib) == %Byte{value: 1, unit: :kib, bytes: 1024}

      assert Byte.new(1.23, :kib) == %Byte{
               value: 1.23,
               unit: :kib,
               bytes: 1024 * 1.23
             }

      assert Byte.new(1.67, :kib) == %Byte{
               value: 1.67,
               unit: :kib,
               bytes: 1024 * 1.67
             }

      assert Byte.new(1, "KiB") == %Byte{value: 1, unit: :kib, bytes: 1024}

      assert Byte.new(1.23, "KiB") == %Byte{
               value: 1.23,
               unit: :kib,
               bytes: 1024 * 1.23
             }

      assert Byte.new(1.67, "KiB") == %Byte{
               value: 1.67,
               unit: :kib,
               bytes: 1024 * 1.67
             }
    end

    test "with unit as FileSize.Units.Info" do
      Enum.each([:b, :kb, :kib], fn unit ->
        unit_info = Units.fetch!(unit)

        assert Byte.new(1337, unit) == Byte.new(1337, unit_info)
      end)
    end

    test "raise on invalid unit" do
      assert_raise ArgumentError,
                   "Unable to use unit :bit for type FileSize.Byte",
                   fn ->
                     Byte.new(1337, :bit)
                   end
    end

    test "raise on unknown unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Byte.new(1337, :unknown)
      end
    end
  end
end

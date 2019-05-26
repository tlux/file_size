defmodule FileSize.ConvertibleTest do
  use ExUnit.Case

  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Convertible
  alias FileSize.InvalidUnitError

  doctest FileSize.Convertible

  describe "new/2" do
    test "new Bit" do
      size = %Bit{value: 1, unit: :kb}

      assert Convertible.new(size, 1000) == %{size | bits: 1000}
    end

    test "new Byte" do
      size = %Byte{value: 1, unit: :kb}

      assert Convertible.new(size, 1000) == %{size | bytes: 1000}
    end
  end

  describe "convert/2" do
    test "get original size when units are the same" do
      size = FileSize.new(1337, :kb)

      assert Convertible.convert(size, :kb) == size
    end

    test "bytes to bits" do
      size = Convertible.convert(FileSize.new(1, :b), :bit)

      assert size == FileSize.new(8, :bit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "bits to bytes" do
      size = Convertible.convert(FileSize.new(8, :bit), :b)

      assert size == FileSize.new(1, :b)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "bits to bytes with truncation" do
      Enum.each([FileSize.new(9, :bit), FileSize.new(15, :bit)], fn size ->
        size_in_bytes = Convertible.convert(size, :b)

        assert size_in_bytes == FileSize.new(1, :b)
        assert is_float(size_in_bytes.value)
        assert is_integer(size_in_bytes.bytes)
      end)
    end

    test "bytes to kilobytes" do
      size = Convertible.convert(FileSize.new(1000, :b), :kb)

      assert size == FileSize.new(1, :kb)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "bytes to kibibytes" do
      size = Convertible.convert(FileSize.new(1024, :b), :kib)

      assert size == FileSize.new(1, :kib)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "kilobytes to bytes" do
      size = Convertible.convert(FileSize.new(1, :kb), :b)

      assert size == FileSize.new(1000, :b)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "kibibytes to bytes" do
      size = Convertible.convert(FileSize.new(1, :kib), :b)

      assert size == FileSize.new(1024, :b)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "bits to kilobits" do
      size = Convertible.convert(FileSize.new(1000, :bit), :kbit)

      assert size == FileSize.new(1, :kbit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "bits to kibibits" do
      size = Convertible.convert(FileSize.new(1024, :bit), :kibit)

      assert size == FileSize.new(1, :kibit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "kilobits to bits" do
      size = Convertible.convert(FileSize.new(1, :kbit), :bit)

      assert size == FileSize.new(1000, :bit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "kibibits to bits" do
      size = Convertible.convert(FileSize.new(1, :kibit), :bit)

      assert size == FileSize.new(1024, :bit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "megabytes to bytes" do
      size = Convertible.convert(FileSize.new(1, :mb), :b)

      assert size == FileSize.new(1_000_000, :b)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "mebibytes to bytes" do
      size = Convertible.convert(FileSize.new(1, :mib), :b)

      assert size == FileSize.new(1_048_576, :b)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "megabytes to kilobytes" do
      size = Convertible.convert(FileSize.new(1, :mb), :kb)

      assert size == FileSize.new(1000, :kb)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "megabytes to kibibytes" do
      size = Convertible.convert(FileSize.new(1, :mb), :kib)

      assert size == FileSize.new(976.5625, :kib)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "mebibytes to kilobytes" do
      size = Convertible.convert(FileSize.new(1, :mib), :kb)

      assert size == FileSize.new(1048.576, :kb)
      assert is_float(size.value)
      assert is_integer(size.bytes)
    end

    test "megabits to bits" do
      size = Convertible.convert(FileSize.new(1, :mbit), :bit)

      assert size == FileSize.new(1_000_000, :bit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "mebibits to bits" do
      size = Convertible.convert(FileSize.new(1, :mibit), :bit)

      assert size == FileSize.new(1_048_576, :bit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "megabits to kilobits" do
      size = Convertible.convert(FileSize.new(1, :mbit), :kbit)

      assert size == FileSize.new(1000, :kbit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "megabits to kibibits" do
      size = Convertible.convert(FileSize.new(1, :mbit), :kibit)

      assert size == FileSize.new(976.5625, :kibit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "mebibits to kilobits" do
      size = Convertible.convert(FileSize.new(1, :mibit), :kbit)

      assert size == FileSize.new(1048.576, :kbit)
      assert is_float(size.value)
      assert is_integer(size.bits)
    end

    test "invalid unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Convertible.convert(FileSize.new(1, :b), :unknown)
      end
    end
  end
end

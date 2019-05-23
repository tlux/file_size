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
      assert Convertible.convert(FileSize.new(1, :b), :bit) ==
               FileSize.new(8, :bit)
    end

    test "bits to bytes" do
      assert Convertible.convert(FileSize.new(8, :bit), :b) ==
               FileSize.new(1, :b)
    end

    test "kilobytes to bytes" do
      assert Convertible.convert(FileSize.new(1, :kb), :b) ==
               FileSize.new(1000, :b)
    end

    test "kibibytes to bytes" do
      assert Convertible.convert(FileSize.new(1, :kib), :b) ==
               FileSize.new(1024, :b)
    end

    test "invalid unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Convertible.convert(FileSize.new(1, :b), :unknown)
      end
    end
  end
end

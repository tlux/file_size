defmodule FileSize.ConvertibleTest do
  use ExUnit.Case

  alias FileSize.Convertible
  alias FileSize.InvalidUnitError

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

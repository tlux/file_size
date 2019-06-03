defmodule FileSize.ConvertibleTest do
  use ExUnit.Case

  alias FileSize.Convertible
  alias FileSize.InvalidUnitError

  doctest FileSize.Convertible

  describe "convert/2" do
    test "get original size when units are the same" do
      size = FileSize.new(1337, :kb)

      assert Convertible.convert(size, :kb) == size
    end

    test "bytes to bits" do
      size = Convertible.convert(FileSize.new(1, :b), :bit)

      assert size == FileSize.new(8, :bit)
    end

    test "bits to bytes" do
      size = Convertible.convert(FileSize.new(8, :bit), :b)

      assert size == FileSize.new(1, :b)
    end

    test "bits to bytes with rounding" do
      assert Convertible.convert(FileSize.new(9, :bit), :b) ==
               FileSize.new(1, :b)

      assert Convertible.convert(FileSize.new(15, :bit), :b) ==
               FileSize.new(2, :b)
    end

    test "bytes to kilobytes" do
      size = Convertible.convert(FileSize.new(1000, :b), :kb)

      assert size == FileSize.new(1, :kb)
    end

    test "bytes to kibibytes" do
      size = Convertible.convert(FileSize.new(1024, :b), :kib)

      assert size == FileSize.new(1, :kib)
    end

    test "kilobytes to bytes" do
      size = Convertible.convert(FileSize.new(1, :kb), :b)

      assert size == FileSize.new(1000, :b)
    end

    test "kibibytes to bytes" do
      size = Convertible.convert(FileSize.new(1, :kib), :b)

      assert size == FileSize.new(1024, :b)
    end

    test "bits to kilobits" do
      size = Convertible.convert(FileSize.new(1000, :bit), :kbit)

      assert size == FileSize.new(1, :kbit)
    end

    test "bits to kibibits" do
      size = Convertible.convert(FileSize.new(1024, :bit), :kibit)

      assert size == FileSize.new(1, :kibit)
    end

    test "kilobits to bits" do
      size = Convertible.convert(FileSize.new(1, :kbit), :bit)

      assert size == FileSize.new(1000, :bit)
    end

    test "kibibits to bits" do
      size = Convertible.convert(FileSize.new(1, :kibit), :bit)

      assert size == FileSize.new(1024, :bit)
    end

    test "megabytes to bytes" do
      size = Convertible.convert(FileSize.new(1, :mb), :b)

      assert size == FileSize.new(1_000_000, :b)
    end

    test "mebibytes to bytes" do
      size = Convertible.convert(FileSize.new(1, :mib), :b)

      assert size == FileSize.new(1_048_576, :b)
    end

    test "megabytes to kilobytes" do
      size = Convertible.convert(FileSize.new(1, :mb), :kb)

      assert size == FileSize.new(1000, :kb)
    end

    test "megabytes to kibibytes" do
      size = Convertible.convert(FileSize.new(1, :mb), :kib)

      assert size == FileSize.new(976.5625, :kib)
    end

    test "mebibytes to kilobytes" do
      size = Convertible.convert(FileSize.new(1, :mib), :kb)

      assert size == FileSize.new(1048.576, :kb)
    end

    test "megabits to bits" do
      size = Convertible.convert(FileSize.new(1, :mbit), :bit)

      assert size == FileSize.new(1_000_000, :bit)
    end

    test "mebibits to bits" do
      size = Convertible.convert(FileSize.new(1, :mibit), :bit)

      assert size == FileSize.new(1_048_576, :bit)
    end

    test "megabits to kilobits" do
      size = Convertible.convert(FileSize.new(1, :mbit), :kbit)

      assert size == FileSize.new(1000, :kbit)
    end

    test "megabits to kibibits" do
      size = Convertible.convert(FileSize.new(1, :mbit), :kibit)

      assert size == FileSize.new(976.5625, :kibit)
    end

    test "mebibits to kilobits" do
      size = Convertible.convert(FileSize.new(1, :mibit), :kbit)

      assert size == FileSize.new(1048.576, :kbit)
    end

    test "invalid unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Convertible.convert(FileSize.new(1, :b), :unknown)
      end
    end
  end
end

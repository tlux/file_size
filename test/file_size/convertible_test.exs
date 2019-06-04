defmodule FileSize.ConvertibleTest do
  use ExUnit.Case

  alias FileSize.Convertible
  alias FileSize.Units

  doctest FileSize.Convertible

  describe "convert/2" do
    test "get original size when units are the same" do
      unit_info = Units.fetch!(:kb)
      size = FileSize.new(1337, unit_info)

      assert Convertible.convert(size, unit_info) == size
    end

    test "bytes to bits" do
      unit_info = Units.fetch!(:bit)
      size = Convertible.convert(FileSize.new(1, :b), unit_info)

      assert size == FileSize.new(8, unit_info)
    end

    test "bits to bytes" do
      unit_info = Units.fetch!(:b)
      size = Convertible.convert(FileSize.new(8, :bit), unit_info)

      assert size == FileSize.new(1, unit_info)
    end

    test "bits to bytes with rounding" do
      unit_info = Units.fetch!(:b)

      assert Convertible.convert(FileSize.new(9, :bit), unit_info) ==
               FileSize.new(1.125, unit_info)

      assert Convertible.convert(FileSize.new(15, :bit), unit_info) ==
               FileSize.new(1.875, unit_info)
    end

    test "bytes to kilobytes" do
      unit_info = Units.fetch!(:kb)
      size = Convertible.convert(FileSize.new(1000, :b), unit_info)

      assert size == FileSize.new(1, unit_info)
    end

    test "bytes to kibibytes" do
      unit_info = Units.fetch!(:kib)
      size = Convertible.convert(FileSize.new(1024, :b), unit_info)

      assert size == FileSize.new(1, unit_info)
    end

    test "kilobytes to bytes" do
      unit_info = Units.fetch!(:b)
      size = Convertible.convert(FileSize.new(1, :kb), unit_info)

      assert size == FileSize.new(1000, unit_info)
    end

    test "kibibytes to bytes" do
      unit_info = Units.fetch!(:b)
      size = Convertible.convert(FileSize.new(1, :kib), unit_info)

      assert size == FileSize.new(1024, unit_info)
    end

    test "bits to kilobits" do
      unit_info = Units.fetch!(:kbit)
      size = Convertible.convert(FileSize.new(1000, :bit), unit_info)

      assert size == FileSize.new(1, unit_info)
    end

    test "bits to kibibits" do
      unit_info = Units.fetch!(:kibit)
      size = Convertible.convert(FileSize.new(1024, :bit), unit_info)

      assert size == FileSize.new(1, unit_info)
    end

    test "kilobits to bits" do
      unit_info = Units.fetch!(:bit)
      size = Convertible.convert(FileSize.new(1, :kbit), unit_info)

      assert size == FileSize.new(1000, unit_info)
    end

    test "kibibits to bits" do
      unit_info = Units.fetch!(:bit)
      size = Convertible.convert(FileSize.new(1, :kibit), unit_info)

      assert size == FileSize.new(1024, unit_info)
    end

    test "megabytes to bytes" do
      unit_info = Units.fetch!(:b)
      size = Convertible.convert(FileSize.new(1, :mb), unit_info)

      assert size == FileSize.new(1_000_000, unit_info)
    end

    test "mebibytes to bytes" do
      unit_info = Units.fetch!(:b)
      size = Convertible.convert(FileSize.new(1, :mib), unit_info)

      assert size == FileSize.new(1_048_576, unit_info)
    end

    test "megabytes to kilobytes" do
      unit_info = Units.fetch!(:kb)
      size = Convertible.convert(FileSize.new(1, :mb), unit_info)

      assert size == FileSize.new(1000, unit_info)
    end

    test "megabytes to kibibytes" do
      unit_info = Units.fetch!(:kib)
      size = Convertible.convert(FileSize.new(1, :mb), unit_info)

      assert size == FileSize.new(976.5625, unit_info)
    end

    test "mebibytes to kilobytes" do
      unit_info = Units.fetch!(:kb)
      size = Convertible.convert(FileSize.new(1, :mib), unit_info)

      assert size == FileSize.new(1048.576, unit_info)
    end

    test "megabits to bits" do
      unit_info = Units.fetch!(:bit)
      size = Convertible.convert(FileSize.new(1, :mbit), unit_info)

      assert size == FileSize.new(1_000_000, unit_info)
    end

    test "mebibits to bits" do
      unit_info = Units.fetch!(:bit)
      size = Convertible.convert(FileSize.new(1, :mibit), unit_info)

      assert size == FileSize.new(1_048_576, unit_info)
    end

    test "megabits to kilobits" do
      unit_info = Units.fetch!(:kbit)
      size = Convertible.convert(FileSize.new(1, :mbit), unit_info)

      assert size == FileSize.new(1000, unit_info)
    end

    test "megabits to kibibits" do
      unit_info = Units.fetch!(:kibit)
      size = Convertible.convert(FileSize.new(1, :mbit), unit_info)

      assert size == FileSize.new(976.5625, unit_info)
    end

    test "mebibits to kilobits" do
      unit_info = Units.fetch!(:kbit)
      size = Convertible.convert(FileSize.new(1, :mibit), unit_info)

      assert size == FileSize.new(1048.576, unit_info)
    end
  end
end

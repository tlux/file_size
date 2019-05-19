defmodule FileSizeTest do
  use ExUnit.Case

  alias FileSize.Bit
  alias FileSize.Byte

  describe "new/1" do
    test "defaults to byte" do
      assert FileSize.new(1) == %Byte{value: 1, unit: :b, bytes: 1}
    end
  end

  describe "new/2" do
    test "bit" do
      assert FileSize.new(1, :bit) == %Bit{value: 1, unit: :bit, bits: 1}
    end

    test "kbit" do
      assert FileSize.new(1, :kbit) == %Bit{value: 1, unit: :kbit, bits: 1000}
    end

    test "kibit" do
      assert FileSize.new(1, :kibit) == %Bit{value: 1, unit: :kibit, bits: 1024}
    end

    test "mbit"

    test "mibit"

    test "gbit"

    test "gibit"

    test "tbit"

    test "tibit"

    test "pbit"

    test "pibit"

    test "ebit"

    test "eibit"

    test "zbit"

    test "zibit"

    test "ybit"

    test "yibit"

    test "b" do
      assert FileSize.new(1, :b) == %Byte{value: 1, unit: :b, bytes: 1}
    end

    test "kb" do
      assert FileSize.new(1, :kb) == %Byte{value: 1, unit: :kb, bytes: 1000}
    end

    test "kib" do
      assert FileSize.new(1, :kib) == %Byte{value: 1, unit: :kib, bytes: 1024}
    end

    test "mb"

    test "mib"

    test "gb"

    test "gib"

    test "tb"

    test "tib"

    test "pb"

    test "pib"

    test "eb"

    test "eib"

    test "zb"

    test "zib"

    test "yb"

    test "yib"

    test "unknown unit"
  end

  describe "convert/2" do
    test "get original size when units are the same" do
      size = FileSize.new(1337, :kb)

      assert FileSize.convert(size, :kb) == size
    end

    test "bytes to bits" do
      assert FileSize.convert(FileSize.new(1, :b), :bit) ==
               FileSize.new(8, :bit)
    end

    test "bits to bytes" do
      assert FileSize.convert(FileSize.new(8, :bit), :b) ==
               FileSize.new(1, :b)
    end

    test "kilobytes to bytes" do
      assert FileSize.convert(FileSize.new(1, :kb), :b) ==
               FileSize.new(1000, :b)
    end

    test "kibibytes to bytes" do
      assert FileSize.convert(FileSize.new(1, :kib), :b) ==
               FileSize.new(1024, :b)
    end
  end
end

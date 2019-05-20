defmodule FileSize.SigilTest do
  use ExUnit.Case

  import FileSize.Sigil

  test "success" do
    assert ~F(12 B) == FileSize.new(12, :b)
    assert ~F(12 bit) == FileSize.new(12, :bit)
    assert ~F(12 kB) == FileSize.new(12, :kb)
    assert ~F(12 GB) == FileSize.new(12, :gb)
    assert ~F(4.2 tb) == FileSize.new(4.2, :tb)
  end

  test "invalid format" do
    ~F(12.4 GB)
  end

  test "invalid unit"
end

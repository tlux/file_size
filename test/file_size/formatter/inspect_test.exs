defmodule FileSize.Formatter.InspectTest do
  use ExUnit.Case

  describe "Kernel.inspect/1" do
    test "format bytes" do
      assert inspect(FileSize.new(1, :b)) == ~s(#FileSize<"1 B">)
      assert inspect(FileSize.new(1, :kb)) == ~s(#FileSize<"1 kB">)
      assert inspect(FileSize.new(1, :kib)) == ~s(#FileSize<"1 KiB">)
      assert inspect(FileSize.new(1, :mb)) == ~s(#FileSize<"1 MB">)
      assert inspect(FileSize.new(1, :mib)) == ~s(#FileSize<"1 MiB">)
      assert inspect(FileSize.new(1.78, :b)) == ~s(#FileSize<"1.78 B">)
      assert inspect(FileSize.new(1.23, :kb)) == ~s(#FileSize<"1.23 kB">)
      assert inspect(FileSize.new(1.23, :kib)) == ~s(#FileSize<"1.23 KiB">)
    end

    test "format bits" do
      assert inspect(FileSize.new(1, :bit)) == ~s(#FileSize<"1 bit">)
      assert inspect(FileSize.new(1, :kbit)) == ~s(#FileSize<"1 kbit">)
      assert inspect(FileSize.new(1, :kibit)) == ~s(#FileSize<"1 Kibit">)
      assert inspect(FileSize.new(1, :mbit)) == ~s(#FileSize<"1 Mbit">)
      assert inspect(FileSize.new(1, :mibit)) == ~s(#FileSize<"1 Mibit">)
      assert inspect(FileSize.new(1.78, :bit)) == ~s(#FileSize<"1.78 bit">)
      assert inspect(FileSize.new(1.23, :kbit)) == ~s(#FileSize<"1.23 kbit">)
      assert inspect(FileSize.new(1.23, :kibit)) == ~s(#FileSize<"1.23 Kibit">)
    end
  end
end

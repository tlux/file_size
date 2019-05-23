defmodule FileSize.InspectTest do
  use ExUnit.Case

  describe "Kernel.inspect/1" do
    test "format bytes" do
      assert inspect(FileSize.new(1, :b)) == ~s(#FileSize<"1 B">)
      assert inspect(FileSize.new(1, :kb)) == ~s(#FileSize<"1.0 kB">)
      assert inspect(FileSize.new(1, :kib)) == ~s(#FileSize<"1.0 KiB">)
      assert inspect(FileSize.new(1, :mb)) == ~s(#FileSize<"1.0 MB">)
      assert inspect(FileSize.new(1, :mib)) == ~s(#FileSize<"1.0 MiB">)
    end

    test "format bits" do
      assert inspect(FileSize.new(1, :bit)) == ~s(#FileSize<"1 bit">)
      assert inspect(FileSize.new(1, :kbit)) == ~s(#FileSize<"1.0 kbit">)
      assert inspect(FileSize.new(1, :kibit)) == ~s(#FileSize<"1.0 Kibit">)
      assert inspect(FileSize.new(1, :mbit)) == ~s(#FileSize<"1.0 Mbit">)
      assert inspect(FileSize.new(1, :mibit)) == ~s(#FileSize<"1.0 Mibit">)
    end
  end
end

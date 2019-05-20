defmodule FileSize.StringFormatterTest do
  use ExUnit.Case

  alias FileSize.Formatter

  describe "Kernel.to_string/1" do
    test "delegate to Formatter for bytes" do
      size = FileSize.new(1, :b)

      assert to_string(size) == Formatter.format(size)
    end

    test "delegate to Formatter for bits" do
      size = FileSize.new(1, :bit)

      assert to_string(size) == Formatter.format(size)
    end
  end
end

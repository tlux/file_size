defmodule FileSize.StringFormatterTest do
  use ExUnit.Case

  alias FileSize.Formatter

  describe "Kernel.to_string/1" do
    test "delegate to Formatter for bytes" do
      Enum.each(
        [FileSize.new(1, :b), FileSize.new(1000, :kb), FileSize.new(100, :kib)],
        fn size ->
          assert to_string(size) == Formatter.format_simple(size)
        end
      )
    end

    test "delegate to Formatter for bits" do
      Enum.each(
        [
          FileSize.new(1, :bit),
          FileSize.new(1000, :kbit),
          FileSize.new(100, :kibit)
        ],
        fn size ->
          assert to_string(size) == Formatter.format_simple(size)
        end
      )
    end
  end
end

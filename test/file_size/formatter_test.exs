defmodule FileSize.FormatterTest do
  use ExUnit.Case

  alias FileSize.Formatter
  alias FileSize.Units

  describe "format/1" do
    test "success" do
      Enum.each(Units.unit_infos(), fn info ->
        assert Formatter.format(FileSize.new(1337, info.name)) ==
                 "1,337.00 #{info.symbol}"

        assert Formatter.format(FileSize.new(1337.6, info.name)) ==
                 "1,337.60 #{info.symbol}"
      end)
    end
  end

  describe "format/2" do
    test "success" do
      Enum.each(Units.unit_infos(), fn info ->
        opts = [separator: ",", delimiter: ".", precision: 1]

        assert Formatter.format(FileSize.new(1337, info.name), opts) ==
                 "1.337,0 #{info.symbol}"

        assert Formatter.format(FileSize.new(1337.6, info.name), opts) ==
                 "1.337,6 #{info.symbol}"
      end)
    end
  end
end

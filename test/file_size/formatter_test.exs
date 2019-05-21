defmodule FileSize.FormatterTest do
  use ExUnit.Case

  alias FileSize.Formatter

  @units [
    # Bit
    {"bit", :bit},
    {"kbit", :kbit},
    {"Kibit", :kibit},
    {"Mbit", :mbit},
    {"Mibit", :mibit},
    {"Gbit", :gbit},
    {"Gibit", :gibit},
    {"Tbit", :tbit},
    {"Tibit", :tibit},
    {"Pbit", :pbit},
    {"Pibit", :pibit},
    {"Ebit", :ebit},
    {"Eibit", :eibit},
    {"Zbit", :zbit},
    {"Zibit", :zibit},
    {"Ybit", :ybit},
    {"Yibit", :yibit},
    # Byte
    {"B", :b},
    {"kB", :kb},
    {"KiB", :kib},
    {"MB", :mb},
    {"MiB", :mib},
    {"GB", :gb},
    {"GiB", :gib},
    {"TB", :tb},
    {"TiB", :tib},
    {"PB", :pb},
    {"PiB", :pib},
    {"EB", :eb},
    {"EiB", :eib},
    {"ZB", :zb},
    {"ZiB", :zib},
    {"YB", :yb},
    {"YiB", :yib}
  ]

  describe "format/1" do
    Enum.each(@units, fn {unit_str, unit} ->
      test "format file size as #{unit_str}" do
        assert Formatter.format(FileSize.new(1337, unquote(unit))) ==
                 "1,337.00 #{unquote(unit_str)}"

        assert Formatter.format(FileSize.new(1337.6, unquote(unit))) ==
                 "1,337.60 #{unquote(unit_str)}"
      end
    end)
  end

  describe "format/2" do
    Enum.each(@units, fn {unit_str, unit} ->
      test "format file size as #{unit_str}" do
        opts = [separator: ",", delimiter: ".", precision: 1]

        assert Formatter.format(FileSize.new(1337, unquote(unit)), opts) ==
                 "1.337,0 #{unquote(unit_str)}"

        assert Formatter.format(FileSize.new(1337.6, unquote(unit)), opts) ==
                 "1.337,6 #{unquote(unit_str)}"
      end
    end)
  end
end

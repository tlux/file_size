defmodule FileSize.FormatterTest do
  use ExUnit.Case, async: false

  alias FileSize.Formatter
  alias FileSize.Units

  setup do
    on_exit(fn ->
      Application.delete_env(:file_size, :number_format)
      Application.delete_env(:file_size, :symbols)
      Application.delete_env(:number, :delimit)
    end)

    :ok
  end

  describe "format/1" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        assert Formatter.format(FileSize.new(1337, info.name)) ==
                 "1,337 #{info.symbol}"

        assert Formatter.format(FileSize.new(1337.6, info.name)) ==
                 "1,338 #{info.symbol}"
      end)
    end
  end

  describe "format/2" do
    test "format with empty options" do
      Enum.each(Units.list(), fn info ->
        assert Formatter.format(FileSize.new(1337, info.name), []) ==
                 "1,337 #{info.symbol}"

        assert Formatter.format(FileSize.new(1337.6, info.name), []) ==
                 "1,338 #{info.symbol}"
      end)
    end

    test "format number part with options" do
      opts = [separator: ",", delimiter: ".", precision: 1]

      assert Formatter.format(FileSize.new(1337, :kb), opts) ==
               "1.337,0 kB"

      assert Formatter.format(FileSize.new(1337.6, :kib), opts) ==
               "1.337,6 KiB"
    end

    test "format number part with file_size app config" do
      Application.put_env(:file_size, :number_format,
        separator: ",",
        delimiter: ".",
        precision: 1
      )

      assert Formatter.format(FileSize.new(1337, :kb), []) ==
               "1.337,0 kB"

      assert Formatter.format(FileSize.new(1337.6, :kib), []) ==
               "1.337,6 KiB"

      assert Formatter.format(FileSize.new(1337, :kb), []) ==
               assert(Formatter.format(FileSize.new(1337, :kb)))
    end

    test "format number part with number app config" do
      Application.put_env(:number, :delimit,
        separator: ",",
        delimiter: ".",
        precision: 1
      )

      assert Formatter.format(FileSize.new(1337, :kb), []) ==
               "1.337,0 kB"

      assert Formatter.format(FileSize.new(1337.6, :kib), []) ==
               "1.337,6 KiB"

      assert Formatter.format(FileSize.new(1337, :kb), []) ==
               assert(Formatter.format(FileSize.new(1337, :kb)))
    end

    test "format unit part with symbols option" do
      symbols = %{kb: "KB"}

      assert Formatter.format(FileSize.new(1337, :kb), symbols: symbols) ==
               "1,337 KB"

      assert Formatter.format(FileSize.new(1337.6, :kib), symbols: symbols) ==
               "1,338 KiB"
    end

    test "format unit part with symbols from config" do
      Application.put_env(:file_size, :symbols, %{kb: "KB"})

      assert Formatter.format(FileSize.new(1337, :kb)) == "1,337 KB"
      assert Formatter.format(FileSize.new(1337.6, :kib)) == "1,338 KiB"
    end
  end

  describe "format_simple/1" do
    test "format bytes" do
      assert Formatter.format_simple(FileSize.new(1, :b)) == "1 B"
      assert Formatter.format_simple(FileSize.new(1, :kb)) == "1 kB"
      assert Formatter.format_simple(FileSize.new(1, :kib)) == "1 KiB"
      assert Formatter.format_simple(FileSize.new(1, :mb)) == "1 MB"
      assert Formatter.format_simple(FileSize.new(1, :mib)) == "1 MiB"
      assert Formatter.format_simple(FileSize.new(1000, :kbit)) == "1000 kbit"
    end

    test "format bits" do
      assert Formatter.format_simple(FileSize.new(1, :bit)) == "1 bit"
      assert Formatter.format_simple(FileSize.new(1, :kbit)) == "1 kbit"
      assert Formatter.format_simple(FileSize.new(1, :kibit)) == "1 Kibit"
      assert Formatter.format_simple(FileSize.new(1, :mbit)) == "1 Mbit"
      assert Formatter.format_simple(FileSize.new(1, :mibit)) == "1 Mibit"
      assert Formatter.format_simple(FileSize.new(1000, :kibit)) == "1000 Kibit"
    end
  end
end

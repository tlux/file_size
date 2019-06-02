defmodule FileSize.ParserTest do
  use ExUnit.Case

  alias FileSize.ParseError
  alias FileSize.Parser
  alias FileSize.Units

  describe "parse/1" do
    test "success with Bit struct" do
      size = FileSize.new(1337, :bit)

      assert Parser.parse(size) == {:ok, size}
    end

    test "success with Byte struct" do
      size = FileSize.new(1337, :b)

      assert Parser.parse(size) == {:ok, size}
    end

    test "success with string" do
      Enum.each(Units.list(), fn info ->
        assert Parser.parse("1337 #{info.symbol}") ==
                 {:ok, FileSize.new(1337, info.name)}

        assert Parser.parse("1337.4 #{info.symbol}") ==
                 {:ok, FileSize.new(1337.4, info.name)}
      end)
    end

    test "invalid format" do
      Enum.each(
        [:invalid, "", " ", "1234", "1234.5", "A B", 12, 12.34],
        fn value ->
          assert Parser.parse(value) ==
                   {:error, %ParseError{reason: :format, value: value}}
        end
      )
    end

    test "invalid value error" do
      Enum.each(["1337,0 B"], fn value ->
        assert Parser.parse(value) ==
                 {:error, %ParseError{reason: :value, value: value}}
      end)
    end

    test "invalid unit error" do
      Enum.each(["1337 U", "1337 ok", "1337.6 U"], fn value ->
        assert Parser.parse(value) ==
                 {:error, %ParseError{reason: :unit, value: value}}
      end)
    end
  end

  describe "parse/2" do
    test "success with Bit struct" do
      size = FileSize.new(1337, :bit)

      assert Parser.parse!(size) == size
    end

    test "success with Byte struct" do
      size = FileSize.new(1337, :b)

      assert Parser.parse!(size) == size
    end

    test "success with string" do
      Enum.each(Units.list(), fn info ->
        assert Parser.parse!("1337 #{info.symbol}") ==
                 FileSize.new(1337, info.name)

        assert Parser.parse!("1337.4 #{info.symbol}") ==
                 FileSize.new(1337.4, info.name)
      end)
    end

    test "invalid format" do
      Enum.each(
        [:invalid, "", " ", "1234", "1234.5", "A B", 12, 12.34],
        fn value ->
          assert_raise ParseError,
                       "Unable to parse value: #{inspect(value)} (format)",
                       fn ->
                         Parser.parse!(value)
                       end
        end
      )
    end

    test "invalid value error" do
      Enum.each(["1337,0 B"], fn value ->
        assert_raise ParseError,
                     "Unable to parse value: #{inspect(value)} (value)",
                     fn ->
                       Parser.parse!(value)
                     end
      end)
    end

    test "invalid unit error" do
      Enum.each(["1337 U", "1337 ok", "1337.6 U"], fn value ->
        assert_raise ParseError,
                     "Unable to parse value: #{inspect(value)} (unit)",
                     fn ->
                       Parser.parse!(value)
                     end
      end)
    end
  end
end

defmodule FileSize.SigilTest do
  use ExUnit.Case

  alias FileSize.ParseError

  import FileSize.Sigil

  test "success" do
    assert ~f(12 B) == FileSize.new(12, :b)
    assert ~f(12 bit) == FileSize.new(12, :bit)
    assert ~f(12 kB) == FileSize.new(12, :kb)
    assert ~f(12 GB) == FileSize.new(12, :gb)
    assert ~f(4.2 tb) == FileSize.new(4.2, :tb)
  end

  test "invalid format" do
    Enum.each(
      ["", " ", "1234", "1234.5", "A B"],
      fn value ->
        assert_raise ParseError,
                     "Unable to parse value: #{inspect(value)} (format)",
                     fn ->
                       ~f(#{value})
                     end
      end
    )
  end

  test "invalid value error" do
    Enum.each(["1337,0 B"], fn value ->
      assert_raise ParseError,
                   "Unable to parse value: #{inspect(value)} (value)",
                   fn ->
                     ~f(#{value})
                   end
    end)
  end

  test "invalid unit error" do
    Enum.each(["1337 U", "1337 ok", "1337.6 U"], fn value ->
      assert_raise ParseError,
                   "Unable to parse value: #{inspect(value)} (unit)",
                   fn ->
                     ~f(#{value})
                   end
    end)
  end
end

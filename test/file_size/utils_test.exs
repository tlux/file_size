defmodule FileSize.UtilsTest do
  use ExUnit.Case

  alias FileSize.Utils

  describe "cast_num/1" do
    test "string to float" do
      assert Utils.cast_num("2.1") == {:ok, 2.1}
    end

    test "string to integer" do
      assert {:ok, value} = Utils.cast_num("2.0")
      assert is_integer(value)
      assert value == 2

      assert {:ok, value} = Utils.cast_num("2")
      assert is_integer(value)
      assert value == 2
    end

    test "float to float" do
      assert Utils.cast_num(2.1) == {:ok, 2.1}
    end

    test "float to integer" do
      assert {:ok, value} = Utils.cast_num(2.0)
      assert is_integer(value)
      assert value == 2
    end

    test "integer to integer" do
      assert {:ok, value} = Utils.cast_num(2)
      assert is_integer(value)
      assert value == 2
    end

    test "decimal to float" do
      assert Utils.cast_num(Decimal.new("2.1")) == {:ok, 2.1}
    end

    test "decimal to integer" do
      assert {:ok, value} = Utils.cast_num(Decimal.new("2"))
      assert is_integer(value)
      assert value == 2
    end

    test "error on invalid value" do
      assert Utils.cast_num("invalid") == :error
      assert Utils.cast_num("2.") == :error
      assert Utils.cast_num("2-invalid") == :error
      assert Utils.cast_num("2.1-invalid") == :error
    end
  end

  describe "cast_num!/1" do
    test "string to float" do
      assert Utils.cast_num!("2.1") == 2.1
    end

    test "string to integer" do
      value = Utils.cast_num!("2.0")
      assert is_integer(value)
      assert value == 2

      value = Utils.cast_num!("2")
      assert is_integer(value)
      assert value == 2
    end

    test "float to float" do
      assert Utils.cast_num!(2.1) == 2.1
    end

    test "float to integer" do
      value = Utils.cast_num!(2.0)

      assert is_integer(value)
      assert value == 2
    end

    test "integer to integer" do
      value = Utils.cast_num!(2)

      assert is_integer(value)
      assert value == 2
    end

    test "decimal to float" do
      assert Utils.cast_num!(Decimal.new("2.1")) == 2.1
    end

    test "decimal to integer" do
      value = Utils.cast_num!(Decimal.new("2"))

      assert is_integer(value)
      assert value == 2
    end

    test "error on invalid value" do
      assert_raise ArgumentError,
                   ~s[Unable to cast value (expected a number or ] <>
                     ~s[binary, got "invalid")],
                   fn ->
                     Utils.cast_num!("invalid")
                   end
    end
  end

  describe "sanitize_num/1" do
    test "float to float" do
      assert Utils.sanitize_num(2.1) == 2.1
    end

    test "float to integer" do
      value = Utils.sanitize_num(2.0)

      assert is_integer(value)
      assert value == 2
    end

    test "integer to integer" do
      value = Utils.sanitize_num(2)

      assert is_integer(value)
      assert value == 2
    end

    test "decimal to float" do
      assert Utils.sanitize_num(Decimal.new("2.1")) == 2.1
    end

    test "decimal to integer" do
      value = Utils.sanitize_num(Decimal.new("2"))

      assert is_integer(value)
      assert value == 2
    end
  end

  describe "compare/2" do
    test "first less than second" do
      assert Utils.compare(1, 2) == :lt
      assert Utils.compare(1, 1.2) == :lt
    end

    test "first equal to second" do
      assert Utils.compare(1, 1) == :eq
      assert Utils.compare(1, 1.0) == :eq
    end

    test "first greater than second" do
      assert Utils.compare(2, 1) == :gt
      assert Utils.compare(2, 1.2) == :gt
    end
  end
end

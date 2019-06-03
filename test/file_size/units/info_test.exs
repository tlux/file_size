defmodule FileSize.Units.InfoTest do
  use ExUnit.Case

  alias FileSize.Units
  alias FileSize.Units.Info

  describe "get_factor/1" do
    test "get 1 when system nil" do
      assert Info.get_factor(%Info{system: nil}) == 1
    end

    test "get 1 when exp 0" do
      assert Info.get_factor(%Info{exp: 0}) == 1
    end

    test "get factors for all unit" do
      Enum.each(Units.list(), fn
        %{system: :si} = info ->
          assert Info.get_factor(info) == Math.pow(1000, info.exp)

        %{system: :iec} = info ->
          assert Info.get_factor(info) == Math.pow(1024, info.exp)

        info ->
          assert Info.get_factor(info) == 1
      end)
    end
  end

  describe "normalize_value/2" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        factor = Info.get_factor(info)

        assert Info.normalize_value(info, 1) ==
                 Decimal.reduce(Decimal.new(factor))

        assert Info.normalize_value(info, 2) ==
                 Decimal.reduce(Decimal.new(2 * factor))

        result = Info.normalize_value(info, 2.2)

        assert Decimal.decimal?(result)
        assert result == Decimal.reduce(Decimal.mult(factor, "2.2"))
      end)
    end
  end

  describe "denormalize_value/2" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        factor = Info.get_factor(info)
        result = Info.denormalize_value(info, 2)

        assert result == Decimal.div(2, factor)
        assert Decimal.decimal?(result)
      end)
    end
  end

  describe "sanitize_value/2" do
    test "round when exp is 0" do
      info = %Info{exp: 0}
      sanitized_value = Decimal.new(2)

      assert Info.sanitize_value(info, 1.54) == sanitized_value
      assert Info.sanitize_value(info, 2) == sanitized_value

      assert Info.sanitize_value(info, Decimal.from_float(2.2)) ==
               sanitized_value
    end

    test "do not round when exp greater than 0" do
      info = %Info{exp: 1}

      assert Info.sanitize_value(info, 1.54) == Decimal.from_float(1.54)
      assert Info.sanitize_value(info, 2) == Decimal.new(2)

      assert Info.sanitize_value(info, Decimal.from_float(2.2)) ==
               Decimal.from_float(2.2)
    end
  end
end

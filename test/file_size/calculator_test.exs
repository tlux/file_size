defmodule FileSize.CalculatorTest do
  use ExUnit.Case

  alias FileSize.Calculator

  describe "normalize/2" do
    test "from kilo" do
      assert Calculator.normalize(1, :kilo) == 1000
      assert Calculator.normalize(2, :kilo) == 2000
    end

    test "from kibi" do
      assert Calculator.normalize(1, :kibi) == 1024
      assert Calculator.normalize(2, :kibi) == 2048
    end

    test "from mega" do
      assert Calculator.normalize(1, :mega) == Math.pow(1000, 2)
    end

    test "from mebi" do
      assert Calculator.normalize(1, :mebi) == Math.pow(1024, 2)
    end

    test "from giga" do
      assert Calculator.normalize(1, :giga) == Math.pow(1000, 3)
    end

    test "from gibi" do
      assert Calculator.normalize(1, :gibi) == Math.pow(1024, 3)
    end

    test "from tera" do
      assert Calculator.normalize(1, :tera) == Math.pow(1000, 4)
    end

    test "from tebi" do
      assert Calculator.normalize(1, :tebi) == Math.pow(1024, 4)
    end

    test "from peta" do
      assert Calculator.normalize(1, :peta) == Math.pow(1000, 5)
    end

    test "from pebi" do
      assert Calculator.normalize(1, :pebi) == Math.pow(1024, 5)
    end

    test "from exa" do
      assert Calculator.normalize(1, :exa) == Math.pow(1000, 6)
    end

    test "from exbi" do
      assert Calculator.normalize(1, :exbi) == Math.pow(1024, 6)
    end

    test "from zeta" do
      assert Calculator.normalize(1, :zeta) == Math.pow(1000, 7)
    end

    test "from zebi" do
      assert Calculator.normalize(1, :zebi) == Math.pow(1024, 7)
    end

    test "from yotta" do
      assert Calculator.normalize(1, :yotta) == Math.pow(1000, 8)
    end

    test "from yobi" do
      assert Calculator.normalize(1, :yobi) == Math.pow(1024, 8)
    end

    test "unknown prefix" do
      assert_raise FunctionClauseError, ~r/no function clause matching/, fn ->
        Calculator.normalize(1, :unknown)
      end
    end
  end

  describe "denormalize/2" do
    test "to kilo" do
      assert Calculator.denormalize(1000, :kilo) == 1
      assert Calculator.denormalize(2000, :kilo) == 2
    end

    test "to kibi" do
      assert Calculator.denormalize(1024, :kibi) == 1
      assert Calculator.denormalize(2048, :kibi) == 2
    end

    test "to mega" do
      assert Calculator.denormalize(Math.pow(1000, 2), :mega) == 1
    end

    test "to mebi" do
      assert Calculator.denormalize(Math.pow(1024, 2), :mebi) == 1
    end

    test "to giga" do
      assert Calculator.denormalize(Math.pow(1000, 3), :giga) == 1
    end

    test "to gibi" do
      assert Calculator.denormalize(Math.pow(1024, 3), :gibi) == 1
    end

    test "to tera" do
      assert Calculator.denormalize(Math.pow(1000, 4), :tera) == 1
    end

    test "to tebi" do
      assert Calculator.denormalize(Math.pow(1024, 4), :tebi) == 1
    end

    test "to peta" do
      assert Calculator.denormalize(Math.pow(1000, 5), :peta) == 1
    end

    test "to pebi" do
      assert Calculator.denormalize(Math.pow(1024, 5), :pebi) == 1
    end

    test "to exa" do
      assert Calculator.denormalize(Math.pow(1000, 6), :exa) == 1
    end

    test "to exbi" do
      assert Calculator.denormalize(Math.pow(1024, 6), :exbi) == 1
    end

    test "to zeta" do
      assert Calculator.denormalize(Math.pow(1000, 7), :zeta) == 1
    end

    test "to zebi" do
      assert Calculator.denormalize(Math.pow(1024, 7), :zebi) == 1
    end

    test "to yotta" do
      assert Calculator.denormalize(Math.pow(1000, 8), :yotta) == 1
    end

    test "to yobi" do
      assert Calculator.denormalize(Math.pow(1024, 8), :yobi) == 1
    end

    test "unknown prefix" do
      assert_raise FunctionClauseError, ~r/no function clause matching/, fn ->
        Calculator.denormalize(1, :unknown)
      end
    end
  end
end

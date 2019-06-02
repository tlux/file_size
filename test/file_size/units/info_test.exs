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

        assert Info.normalize_value(info, 1) == factor
        assert Info.normalize_value(info, 2) == 2 * factor

        result = Info.normalize_value(info, 2.2)
        assert result == trunc(2.2 * factor)
        assert is_integer(result)
      end)
    end
  end

  describe "denormalize_value/2" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        factor = Info.get_factor(info)
        result = Info.denormalize_value(info, 2)

        assert result == 2 / factor
        assert is_float(result)
      end)
    end
  end
end

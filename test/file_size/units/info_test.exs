defmodule FileSize.Units.InfoTest do
  use ExUnit.Case

  alias FileSize.Units
  alias FileSize.Units.Info

  describe "normalize_value/2" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        value = Info.normalize_value(info, 1)
        assert is_integer(value)
        assert value == info.coeff

        value = Info.normalize_value(info, 2)
        assert is_integer(value)
        assert value == 2 * info.coeff

        value = Info.normalize_value(info, 2.2)
        assert is_number(value)
        assert value == 2.2 * info.coeff
      end)
    end
  end

  describe "denormalize_value/2" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        assert Info.denormalize_value(info, 1) == 1 / info.coeff
        assert Info.denormalize_value(info, 2) == 2 / info.coeff
        assert Info.denormalize_value(info, 2.2) == 2.2 / info.coeff
      end)
    end
  end
end

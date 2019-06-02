defmodule FileSize.UnitsTest do
  use ExUnit.Case

  alias FileSize.InvalidUnitError
  alias FileSize.Units

  describe "fetch/1" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        assert Units.fetch(info.name) == {:ok, info}
      end)
    end

    test "error" do
      assert Units.fetch(:unknown) == :error
    end
  end

  describe "fetch!/1" do
    test "success" do
      Enum.each(Units.list(), fn info ->
        assert Units.fetch!(info.name) == info
      end)
    end

    test "error" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        Units.fetch!(:unknown)
      end
    end
  end
end

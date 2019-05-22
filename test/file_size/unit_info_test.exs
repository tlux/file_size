defmodule FileSize.UnitInfoTest do
  use ExUnit.Case

  alias FileSize.UnitInfo
  alias FileSize.Units

  describe "get_factor/1" do
    test "get 1 when system nil" do
      assert UnitInfo.get_factor(%UnitInfo{system: nil}) == 1
    end

    test "get 1 when exp 0" do
      assert UnitInfo.get_factor(%UnitInfo{exp: 0}) == 1
    end

    test "get factors for all unit" do
      Enum.each(Units.unit_infos(), fn
        %{system: :si} = info ->
          assert UnitInfo.get_factor(info) == Math.pow(1000, info.exp)

        %{system: :iec} = info ->
          assert UnitInfo.get_factor(info) == Math.pow(1024, info.exp)

        info ->
          assert UnitInfo.get_factor(info) == 1
      end)
    end
  end
end

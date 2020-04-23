defmodule FileSize.Units.InfoTest do
  use ExUnit.Case

  alias FileSize.Units
  alias FileSize.Units.Info

  describe "new/1" do
    test "build info" do
      assert Info.new(
               exp: 3,
               mod: FileSize.Byte,
               name: :gb,
               symbol: "GB",
               system: :si
             ) == %Info{
               coeff: 1_000_000_000,
               exp: 3,
               max_value: 999_999_999_999,
               min_value: 1_000_000_000,
               mod: FileSize.Byte,
               name: :gb,
               symbol: "GB",
               system: :si
             }

      assert Info.new(
               exp: 2,
               mod: FileSize.Bit,
               name: :mibit,
               symbol: "Mibit",
               system: :iec
             ) == %Info{
               coeff: 1_048_576,
               exp: 2,
               max_value: 1_073_741_823,
               min_value: 1_048_576,
               mod: FileSize.Bit,
               name: :mibit,
               symbol: "Mibit",
               system: :iec
             }
    end
  end

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

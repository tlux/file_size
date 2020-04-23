defmodule FileSize.ComparableTest do
  use ExUnit.Case

  alias FileSize.Comparable

  describe "compare/2" do
    test "first less than second" do
      assert Comparable.compare(FileSize.new(1, :b), FileSize.new(2, :b)) == :lt

      assert Comparable.compare(FileSize.new(1, :bit), FileSize.new(1, :b)) ==
               :lt

      assert Comparable.compare(FileSize.new(1, :bit), FileSize.new(2, :bit)) ==
               :lt

      assert Comparable.compare(FileSize.new(1, :b), FileSize.new(1, :kb)) ==
               :lt

      assert Comparable.compare(FileSize.new(1, :b), FileSize.new(1, :kib)) ==
               :lt

      assert Comparable.compare(FileSize.new(2, :b), FileSize.new(17, :bit)) ==
               :lt
    end

    test "first equal to second" do
      assert Comparable.compare(FileSize.new(1, :b), FileSize.new(1, :b)) == :eq

      assert Comparable.compare(FileSize.new(1, :bit), FileSize.new(1, :bit)) ==
               :eq

      assert Comparable.compare(FileSize.new(8, :bit), FileSize.new(1, :b)) ==
               :eq

      assert Comparable.compare(FileSize.new(1000, :b), FileSize.new(1, :kb)) ==
               :eq

      assert Comparable.compare(FileSize.new(2, :b), FileSize.new(16, :bit)) ==
               :eq
    end

    test "first greater than second" do
      assert Comparable.compare(FileSize.new(2, :b), FileSize.new(1, :b)) == :gt

      assert Comparable.compare(FileSize.new(2, :b), FileSize.new(1, :bit)) ==
               :gt

      assert Comparable.compare(FileSize.new(2, :bit), FileSize.new(1, :bit)) ==
               :gt

      assert Comparable.compare(FileSize.new(1, :kb), FileSize.new(1, :b)) ==
               :gt

      assert Comparable.compare(FileSize.new(1, :kib), FileSize.new(1, :b)) ==
               :gt

      assert Comparable.compare(FileSize.new(2, :b), FileSize.new(15, :bit)) ==
               :gt
    end
  end
end

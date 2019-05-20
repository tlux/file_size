defmodule FileSize.ComparableTest do
  use ExUnit.Case

  alias FileSize.Comparable

  describe "compare/2" do
    test "first less than second" do
      assert Comparable.compare(FileSize.new(1, :b), FileSize.new(2, :b)) == -1

      assert Comparable.compare(FileSize.new(1, :bit), FileSize.new(2, :b)) ==
               -1

      assert Comparable.compare(FileSize.new(1, :bit), FileSize.new(2, :bit)) ==
               -1

      assert Comparable.compare(FileSize.new(1, :b), FileSize.new(1, :kb)) == -1

      assert Comparable.compare(FileSize.new(1, :b), FileSize.new(1, :kib)) ==
               -1
    end

    test "first equal to second" do
      assert Comparable.compare(FileSize.new(1, :b), FileSize.new(1, :b)) == 0

      assert Comparable.compare(FileSize.new(1, :bit), FileSize.new(1, :bit)) ==
               0

      assert Comparable.compare(FileSize.new(8, :bit), FileSize.new(1, :b)) == 0

      assert Comparable.compare(FileSize.new(1000, :b), FileSize.new(1, :kb)) ==
               0
    end

    test "first greater than second" do
      assert Comparable.compare(FileSize.new(2, :b), FileSize.new(1, :b)) == 1
      assert Comparable.compare(FileSize.new(2, :b), FileSize.new(1, :bit)) == 1

      assert Comparable.compare(FileSize.new(2, :bit), FileSize.new(1, :bit)) ==
               1

      assert Comparable.compare(FileSize.new(1, :kb), FileSize.new(1, :b)) == 1
      assert Comparable.compare(FileSize.new(1, :kib), FileSize.new(1, :b)) == 1
    end
  end
end

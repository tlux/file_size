defmodule FileSize.CalculableTest do
  use ExUnit.Case

  alias FileSize.Calculable

  doctest FileSize.Calculable

  describe "add/2" do
    test "add byte and byte" do
      assert Calculable.add(FileSize.new(1, :b), FileSize.new(1, :b)) ==
               FileSize.new(2, :b)
    end

    test "add byte and bit" do
      assert Calculable.add(FileSize.new(1, :b), FileSize.new(1, :bit)) ==
               FileSize.new(9, :bit)
    end

    test "add bit and bit" do
      assert Calculable.add(FileSize.new(1, :bit), FileSize.new(1, :bit)) ==
               FileSize.new(2, :bit)
    end

    test "add bit and byte" do
      assert Calculable.add(FileSize.new(1, :bit), FileSize.new(1, :b)) ==
               FileSize.new(9, :bit)
    end
  end

  describe "subtract/2" do
    test "subtract byte and byte" do
      assert Calculable.subtract(FileSize.new(2, :b), FileSize.new(1, :b)) ==
               FileSize.new(1, :b)
    end

    test "subtract byte and bit" do
      assert Calculable.subtract(FileSize.new(1, :b), FileSize.new(1, :bit)) ==
               FileSize.new(7, :bit)
    end

    test "subtract bit and bit" do
      assert Calculable.subtract(FileSize.new(2, :bit), FileSize.new(1, :bit)) ==
               FileSize.new(1, :bit)
    end

    test "subtract bit and byte" do
      assert Calculable.subtract(FileSize.new(9, :bit), FileSize.new(1, :b)) ==
               FileSize.new(1, :bit)
    end
  end
end

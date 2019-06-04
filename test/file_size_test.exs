defmodule FileSizeTest do
  use ExUnit.Case

  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Calculable
  alias FileSize.Comparable
  alias FileSize.Convertible
  alias FileSize.Formatter
  alias FileSize.InvalidUnitError
  alias FileSize.InvalidUnitSystemError
  alias FileSize.Parser

  doctest FileSize,
    except: [
      :moduledoc,
      from_file: 1,
      from_file: 2,
      from_file!: 1,
      from_file!: 2
    ]

  describe "new/1" do
    test "use byte as default unit" do
      assert FileSize.new(1) == %Byte{
               value: 1,
               unit: :b,
               bytes: 1
             }
    end
  end

  describe "new/2" do
    test "bit" do
      assert FileSize.new(1, :bit) == %Bit{
               value: 1,
               unit: :bit,
               bits: 1
             }
    end

    test "kbit" do
      assert FileSize.new(1, :kbit) == %Bit{
               value: 1,
               unit: :kbit,
               bits: 1000
             }
    end

    test "Kibit" do
      assert FileSize.new(1, :kibit) == %Bit{
               value: 1,
               unit: :kibit,
               bits: 1024
             }
    end

    test "Mbit" do
      assert FileSize.new(1, :mbit) == %Bit{
               value: 1,
               unit: :mbit,
               bits: Math.pow(1000, 2)
             }
    end

    test "Mibit" do
      assert FileSize.new(1, :mibit) == %Bit{
               value: 1,
               unit: :mibit,
               bits: Math.pow(1024, 2)
             }
    end

    test "Gbit" do
      assert FileSize.new(1, :gbit) == %Bit{
               value: 1,
               unit: :gbit,
               bits: Math.pow(1000, 3)
             }
    end

    test "Gibit" do
      assert FileSize.new(1, :gibit) == %Bit{
               value: 1,
               unit: :gibit,
               bits: Math.pow(1024, 3)
             }
    end

    test "Tbit" do
      assert FileSize.new(1, :tbit) == %Bit{
               value: 1,
               unit: :tbit,
               bits: Math.pow(1000, 4)
             }
    end

    test "Tibit" do
      assert FileSize.new(1, :tibit) == %Bit{
               value: 1,
               unit: :tibit,
               bits: Math.pow(1024, 4)
             }
    end

    test "Pbit" do
      assert FileSize.new(1, :pbit) == %Bit{
               value: 1,
               unit: :pbit,
               bits: Math.pow(1000, 5)
             }
    end

    test "Pibit" do
      assert FileSize.new(1, :pibit) == %Bit{
               value: 1,
               unit: :pibit,
               bits: Math.pow(1024, 5)
             }
    end

    test "Ebit" do
      assert FileSize.new(1, :ebit) == %Bit{
               value: 1,
               unit: :ebit,
               bits: Math.pow(1000, 6)
             }
    end

    test "Eibit" do
      assert FileSize.new(1, :eibit) == %Bit{
               value: 1,
               unit: :eibit,
               bits: Math.pow(1024, 6)
             }
    end

    test "Zbit" do
      assert FileSize.new(1, :zbit) == %Bit{
               value: 1,
               unit: :zbit,
               bits: Math.pow(1000, 7)
             }
    end

    test "Zibit" do
      assert FileSize.new(1, :zibit) == %Bit{
               value: 1,
               unit: :zibit,
               bits: Math.pow(1024, 7)
             }
    end

    test "Ybit" do
      assert FileSize.new(1, :ybit) == %Bit{
               value: 1,
               unit: :ybit,
               bits: Math.pow(1000, 8)
             }
    end

    test "Yibit" do
      assert FileSize.new(1, :yibit) == %Bit{
               value: 1,
               unit: :yibit,
               bits: Math.pow(1024, 8)
             }
    end

    test "byte" do
      assert FileSize.new(1, :b) == %Byte{
               value: 1,
               unit: :b,
               bytes: 1
             }
    end

    test "kB" do
      assert FileSize.new(1, :kb) == %Byte{
               value: 1,
               unit: :kb,
               bytes: 1000
             }
    end

    test "KiB" do
      assert FileSize.new(1, :kib) == %Byte{
               value: 1,
               unit: :kib,
               bytes: 1024
             }
    end

    test "MB" do
      assert FileSize.new(1, :mb) == %Byte{
               value: 1,
               unit: :mb,
               bytes: Math.pow(1000, 2)
             }
    end

    test "MiB" do
      assert FileSize.new(1, :mib) == %Byte{
               value: 1,
               unit: :mib,
               bytes: Math.pow(1024, 2)
             }
    end

    test "GB" do
      assert FileSize.new(1, :gb) == %Byte{
               value: 1,
               unit: :gb,
               bytes: Math.pow(1000, 3)
             }
    end

    test "GiB" do
      assert FileSize.new(1, :gib) == %Byte{
               value: 1,
               unit: :gib,
               bytes: Math.pow(1024, 3)
             }
    end

    test "TB" do
      assert FileSize.new(1, :tb) == %Byte{
               value: 1,
               unit: :tb,
               bytes: Math.pow(1000, 4)
             }
    end

    test "TiB" do
      assert FileSize.new(1, :tib) == %Byte{
               value: 1,
               unit: :tib,
               bytes: Math.pow(1024, 4)
             }
    end

    test "PB" do
      assert FileSize.new(1, :pb) == %Byte{
               value: 1,
               unit: :pb,
               bytes: Math.pow(1000, 5)
             }
    end

    test "PiB" do
      assert FileSize.new(1, :pib) == %Byte{
               value: 1,
               unit: :pib,
               bytes: Math.pow(1024, 5)
             }
    end

    test "EB" do
      assert FileSize.new(1, :eb) == %Byte{
               value: 1,
               unit: :eb,
               bytes: Math.pow(1000, 6)
             }
    end

    test "EiB" do
      assert FileSize.new(1, :eib) == %Byte{
               value: 1,
               unit: :eib,
               bytes: Math.pow(1024, 6)
             }
    end

    test "ZB" do
      assert FileSize.new(1, :zb) == %Byte{
               value: 1,
               unit: :zb,
               bytes: Math.pow(1000, 7)
             }
    end

    test "ZiB" do
      assert FileSize.new(1, :zib) == %Byte{
               value: 1,
               unit: :zib,
               bytes: Math.pow(1024, 7)
             }
    end

    test "YB" do
      assert FileSize.new(1, :yb) == %Byte{
               value: 1,
               unit: :yb,
               bytes: Math.pow(1000, 8)
             }
    end

    test "YiB" do
      assert FileSize.new(1, :yib) == %Byte{
               value: 1,
               unit: :yib,
               bytes: Math.pow(1024, 8)
             }
    end

    test "unknown unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        FileSize.new(1, :unknown)
      end
    end

    test "invalid value" do
      assert_raise ArgumentError,
                   ~s[Value must be number, Decimal or string (got "invalid")],
                   fn ->
                     FileSize.new("invalid", :b)
                   end

      assert_raise ArgumentError,
                   ~s[Value must be number, Decimal or string (got :invalid)],
                   fn ->
                     FileSize.new(:invalid, :b)
                   end
    end
  end

  describe "from_bytes/2" do
    test "as bytes" do
      assert FileSize.from_bytes(1337, :b) == FileSize.new(1337, :b)
    end

    test "as kB" do
      assert FileSize.from_bytes(1337, :kb) == FileSize.new(1.337, :kb)
    end

    test "invalid unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        FileSize.from_bytes(1337, :unknown)
      end
    end
  end

  describe "from_bits/2" do
    test "as bits" do
      assert FileSize.from_bits(1337, :bit) == FileSize.new(1337, :bit)
    end

    test "as kbits" do
      assert FileSize.from_bits(1337, :kbit) == FileSize.new(1.337, :kbit)
    end

    test "invalid unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        FileSize.from_bits(1337, :unknown)
      end
    end
  end

  describe "from_file/1" do
    test "success on file" do
      path = "test/fixtures/sample.txt"
      %{size: bytes} = File.stat!(path)

      assert FileSize.from_file(path) == {:ok, FileSize.new(bytes)}
    end

    test "file not found" do
      assert FileSize.from_file("test/fixtures/unknown.txt") ==
               {:error, :enoent}
    end
  end

  describe "from_file/2" do
    setup do
      path = "test/fixtures/sample.txt"
      %{size: bytes} = File.stat!(path)
      {:ok, path: "test/fixtures/sample.txt", bytes: bytes}
    end

    test "success with unit", %{path: path, bytes: bytes} do
      assert FileSize.from_file(path, :kb) ==
               {:ok, FileSize.from_bytes(bytes, :kb)}
    end

    test "success with unit system", %{path: path, bytes: bytes} do
      assert FileSize.from_file(path, {:system, :si}) ==
               {:ok, FileSize.from_bytes(bytes, {:system, :si})}

      assert FileSize.from_file(path, {:system, :iec}) ==
               {:ok, FileSize.from_bytes(bytes, {:system, :iec})}
    end

    test "file not found" do
      assert FileSize.from_file("test/fixtures/unknown.txt", :kb) ==
               {:error, :enoent}
    end

    test "invalid unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        FileSize.from_file("test/fixtures/sample.txt", :unknown)
      end
    end
  end

  describe "from_file!/1" do
    test "success" do
      path = "test/fixtures/sample.txt"
      %{size: bytes} = File.stat!(path)

      assert FileSize.from_file!(path) == FileSize.new(bytes)
    end

    test "file not found" do
      assert_raise File.Error, ~r/no such file or directory/, fn ->
        FileSize.from_file!("test/fixtures/unknown.txt")
      end
    end
  end

  describe "from_file!/2" do
    test "success" do
      path = "test/fixtures/sample.txt"
      %{size: bytes} = File.stat!(path)

      assert FileSize.from_file!(path, :kb) == FileSize.from_bytes(bytes, :kb)
    end

    test "file not found" do
      assert_raise File.Error, ~r/no such file or directory/, fn ->
        FileSize.from_file!("test/fixtures/unknown.txt", :kb)
      end
    end

    test "invalid unit" do
      assert_raise InvalidUnitError, "Invalid unit: :unknown", fn ->
        FileSize.from_file!("test/fixtures/sample.txt", :unknown)
      end
    end
  end

  describe "parse/1" do
    test "delegate to Parser" do
      value = "1 GB"

      assert FileSize.parse(value) == Parser.parse(value)
    end
  end

  describe "parse!/1" do
    test "delegate to Parser" do
      value = "1 GB"

      assert FileSize.parse!(value) == Parser.parse!(value)
    end
  end

  describe "format/1" do
    test "delegate to Formatter" do
      size = FileSize.new(1024, :mb)

      assert FileSize.format(size) == Formatter.format(size)
    end
  end

  describe "format/2" do
    test "delegate to Formatter" do
      size = FileSize.new(1024, :mb)
      opts = [delimiter: ",", separator: "."]

      assert FileSize.format(size, opts) == Formatter.format(size, opts)
    end
  end

  describe "convert/2" do
    test "convert to unit" do
      size = FileSize.new(1, :b)

      assert FileSize.convert(size, :bit) == Convertible.convert(size, :bit)
    end

    test "no-op when converting bytes to unit system" do
      size = FileSize.new(1337, :b)

      assert FileSize.convert(size, {:system, :si}) == size
      assert FileSize.convert(size, {:system, :iec}) == size
    end

    test "no-op when converting bits to unit system" do
      size = FileSize.new(1337, :bit)

      assert FileSize.convert(size, {:system, :si}) == size
      assert FileSize.convert(size, {:system, :iec}) == size
    end

    test "convert SI to SI unit system" do
      size = FileSize.new(1337, :kb)

      assert FileSize.convert(size, {:system, :si}) == size
    end

    test "convert IEC to IEC unit system" do
      size = FileSize.new(1337, :kib)

      assert FileSize.convert(size, {:system, :iec}) == size
    end

    test "convert SI to IEC unit system" do
      size = FileSize.new(1337, :kb)

      assert FileSize.convert(size, {:system, :iec}) ==
               FileSize.convert(size, :kib)
    end

    test "convert IEC to SI unit system" do
      size = FileSize.new(1337, :kib)

      assert FileSize.convert(size, {:system, :si}) ==
               FileSize.convert(size, :kb)
    end

    test "invalid unit" do
      assert_raise InvalidUnitError,
                   "Invalid unit: :unknown",
                   fn ->
                     assert FileSize.convert(
                              FileSize.new(1337, :kb),
                              :unknown
                            )
                   end
    end

    test "invalid unit system" do
      assert_raise InvalidUnitSystemError,
                   "Invalid unit system: :unknown",
                   fn ->
                     assert FileSize.convert(
                              FileSize.new(1337, :kb),
                              {:system, :unknown}
                            )
                   end
    end
  end

  describe "compare/2" do
    test "delegate to Calculable" do
      a = FileSize.new(1, :b)
      b = FileSize.new(2, :b)

      assert FileSize.compare(a, b) == Comparable.compare(a, b)
    end
  end

  describe "equals?/2" do
    test "true when first equal to second" do
      assert FileSize.equals?(FileSize.new(1, :b), FileSize.new(1, :b)) == true

      assert FileSize.equals?(FileSize.new(1, :bit), FileSize.new(1, :bit)) ==
               true

      assert FileSize.equals?(FileSize.new(8, :bit), FileSize.new(1, :b)) ==
               true

      assert FileSize.equals?(FileSize.new(1000, :b), FileSize.new(1, :kb)) ==
               true

      assert FileSize.equals?(FileSize.new(2, :b), FileSize.new(16, :bit)) ==
               true
    end

    test "false when first not equal to second" do
      assert FileSize.equals?(FileSize.new(1, :b), FileSize.new(2, :b)) == false

      assert FileSize.equals?(FileSize.new(1, :bit), FileSize.new(2, :b)) ==
               false

      assert FileSize.equals?(FileSize.new(1, :bit), FileSize.new(2, :bit)) ==
               false

      assert FileSize.equals?(FileSize.new(1, :b), FileSize.new(1, :kb)) ==
               false

      assert FileSize.equals?(FileSize.new(1, :b), FileSize.new(1, :kib)) ==
               false

      assert FileSize.equals?(FileSize.new(2, :b), FileSize.new(1, :b)) == false

      assert FileSize.equals?(FileSize.new(2, :b), FileSize.new(1, :bit)) ==
               false

      assert FileSize.equals?(FileSize.new(2, :bit), FileSize.new(1, :bit)) ==
               false

      assert FileSize.equals?(FileSize.new(1, :kb), FileSize.new(1, :b)) ==
               false

      assert FileSize.equals?(FileSize.new(1, :kib), FileSize.new(1, :b)) ==
               false

      assert FileSize.equals?(FileSize.new(2, :b), FileSize.new(17, :bit)) ==
               false
    end
  end

  describe "lt?/2" do
    test "true when first is less than second" do
      assert FileSize.lt?(FileSize.new(1, :b), FileSize.new(2, :b)) == true
      assert FileSize.lt?(FileSize.new(1, :bit), FileSize.new(2, :bit)) == true
      assert FileSize.lt?(FileSize.new(1, :b), FileSize.new(9, :bit)) == true
      assert FileSize.lt?(FileSize.new(7, :bit), FileSize.new(1, :b)) == true
    end

    test "false when first is equal to second" do
      assert FileSize.lt?(FileSize.new(1, :b), FileSize.new(1, :b)) == false
      assert FileSize.lt?(FileSize.new(1, :bit), FileSize.new(1, :bit)) == false
      assert FileSize.lt?(FileSize.new(1, :b), FileSize.new(8, :bit)) == false
      assert FileSize.lt?(FileSize.new(8, :bit), FileSize.new(1, :b)) == false
    end

    test "false when first is greater than second" do
      assert FileSize.lt?(FileSize.new(2, :b), FileSize.new(1, :b)) == false
      assert FileSize.lt?(FileSize.new(2, :bit), FileSize.new(1, :bit)) == false
      assert FileSize.lt?(FileSize.new(1, :b), FileSize.new(7, :bit)) == false
      assert FileSize.lt?(FileSize.new(9, :bit), FileSize.new(1, :b)) == false
    end
  end

  describe "lteq?/2" do
    test "true when first is less than second" do
      assert FileSize.lteq?(FileSize.new(1, :b), FileSize.new(2, :b)) == true

      assert FileSize.lteq?(FileSize.new(1, :bit), FileSize.new(2, :bit)) ==
               true

      assert FileSize.lteq?(FileSize.new(1, :b), FileSize.new(9, :bit)) == true
      assert FileSize.lteq?(FileSize.new(7, :bit), FileSize.new(1, :b)) == true
    end

    test "true when first is equal to second" do
      assert FileSize.lteq?(FileSize.new(1, :b), FileSize.new(1, :b)) == true

      assert FileSize.lteq?(FileSize.new(1, :bit), FileSize.new(1, :bit)) ==
               true

      assert FileSize.lteq?(FileSize.new(1, :b), FileSize.new(8, :bit)) == true
      assert FileSize.lteq?(FileSize.new(8, :bit), FileSize.new(1, :b)) == true
    end

    test "false when first is greater than second" do
      assert FileSize.lteq?(FileSize.new(2, :b), FileSize.new(1, :b)) == false

      assert FileSize.lteq?(FileSize.new(2, :bit), FileSize.new(1, :bit)) ==
               false

      assert FileSize.lteq?(FileSize.new(1, :b), FileSize.new(7, :bit)) == false
      assert FileSize.lteq?(FileSize.new(9, :bit), FileSize.new(1, :b)) == false
    end
  end

  describe "gt?/2" do
    test "false when first is less than second" do
      assert FileSize.gt?(FileSize.new(1, :b), FileSize.new(2, :b)) == false
      assert FileSize.gt?(FileSize.new(1, :bit), FileSize.new(2, :bit)) == false
      assert FileSize.gt?(FileSize.new(1, :b), FileSize.new(9, :bit)) == false
      assert FileSize.gt?(FileSize.new(7, :bit), FileSize.new(1, :b)) == false
    end

    test "false when first is equal to second" do
      assert FileSize.gt?(FileSize.new(1, :b), FileSize.new(1, :b)) == false
      assert FileSize.gt?(FileSize.new(1, :bit), FileSize.new(1, :bit)) == false
      assert FileSize.gt?(FileSize.new(1, :b), FileSize.new(8, :bit)) == false
      assert FileSize.gt?(FileSize.new(8, :bit), FileSize.new(1, :b)) == false
    end

    test "true when first is greater than second" do
      assert FileSize.gt?(FileSize.new(2, :b), FileSize.new(1, :b)) == true
      assert FileSize.gt?(FileSize.new(2, :bit), FileSize.new(1, :bit)) == true
      assert FileSize.gt?(FileSize.new(1, :b), FileSize.new(7, :bit)) == true
      assert FileSize.gt?(FileSize.new(9, :bit), FileSize.new(1, :b)) == true
    end
  end

  describe "gteq?/2" do
    test "false when first is less than second" do
      assert FileSize.gteq?(FileSize.new(1, :b), FileSize.new(2, :b)) == false

      assert FileSize.gteq?(FileSize.new(1, :bit), FileSize.new(2, :bit)) ==
               false

      assert FileSize.gteq?(FileSize.new(1, :b), FileSize.new(9, :bit)) == false
      assert FileSize.gteq?(FileSize.new(7, :bit), FileSize.new(1, :b)) == false
    end

    test "true when first is equal to second" do
      assert FileSize.gteq?(FileSize.new(1, :b), FileSize.new(1, :b)) == true

      assert FileSize.gteq?(FileSize.new(1, :bit), FileSize.new(1, :bit)) ==
               true

      assert FileSize.gteq?(FileSize.new(1, :b), FileSize.new(8, :bit)) == true
      assert FileSize.gteq?(FileSize.new(8, :bit), FileSize.new(1, :b)) == true
    end

    test "true when first is greater than second" do
      assert FileSize.gteq?(FileSize.new(2, :b), FileSize.new(1, :b)) == true

      assert FileSize.gteq?(FileSize.new(2, :bit), FileSize.new(1, :bit)) ==
               true

      assert FileSize.gteq?(FileSize.new(1, :b), FileSize.new(7, :bit)) == true
      assert FileSize.gteq?(FileSize.new(9, :bit), FileSize.new(1, :b)) == true
    end
  end

  describe "add/2" do
    test "delegate to Calculable" do
      a = FileSize.new(1, :b)
      b = FileSize.new(2, :b)

      assert FileSize.add(a, b) == Calculable.add(a, b)
    end
  end

  describe "add/3" do
    test "delegate to Calculable and convert to unit" do
      a = FileSize.new(1, :b)
      b = FileSize.new(2, :b)

      assert FileSize.add(a, b, :kb) ==
               FileSize.convert(Calculable.add(a, b), :kb)
    end

    test "delegate to Calculable and convert to unit system" do
      a = FileSize.new(1, :kb)
      b = FileSize.new(2, :kb)

      assert FileSize.add(a, b, {:system, :iec}) ==
               FileSize.convert(Calculable.add(a, b), :kib)
    end
  end

  describe "subtract/2" do
    test "delegate to Calculable" do
      a = FileSize.new(2, :b)
      b = FileSize.new(1, :b)

      assert FileSize.subtract(a, b) == Calculable.subtract(a, b)
    end
  end

  describe "subtract/3" do
    test "delegate to Calculable and convert to unit" do
      a = FileSize.new(2, :b)
      b = FileSize.new(1, :b)

      assert FileSize.subtract(a, b, :kb) ==
               FileSize.convert(Calculable.subtract(a, b), :kb)
    end

    test "delegate to Calculable and convert to unit system" do
      a = FileSize.new(3, :kb)
      b = FileSize.new(1, :kb)

      assert FileSize.subtract(a, b, {:system, :iec}) ==
               FileSize.convert(Calculable.subtract(a, b), :kib)
    end
  end
end

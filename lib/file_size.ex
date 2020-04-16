defmodule FileSize do
  @moduledoc """
  A file size calculator, parser and formatter.

  ## Usage

  You can build your own file size by creating it with a number and a unit using
  the `new/2` function. See the "Supported Units" section for a list of possible
  unit atoms.

      iex> FileSize.new(16, :gb)
      #FileSize<"16.0 GB">

      iex> FileSize.new(16, "GB")
      #FileSize<"16.0 GB">

  ### Sigil

  There is also a sigil defined that you can use to quickly build file sizes
  from a number and unit symbol. Import the `FileSize.Sigil` module and you are
  ready to go. See the "Supported Units" section for a list of possible unit
  symbols.

      iex> import FileSize.Sigil
      ...>
      ...> ~F(16 GB)
      #FileSize<"16.0 GB">

  ### From File

  With `from_file/1` it is also possible to retrieve the size of an actual file.

      iex> FileSize.from_file("path/to/my/file.txt")
      {:ok, #FileSize<"127.3 kB">}

  ### Conversions

  You can convert file sizes between different units or unit systems by using
  the `convert/2` function.

  ### Calculations

  You can calculate with file sizes. The particular units don't need to be the
  same for that.

  * `add/2` - Add two file sizes.
  * `subtract/2` - Subtracts two file sizes.

  ### Comparison

  For comparison the units of the particular file sizes don't need to be the
  same.

  * `compare/2` - Compares two file sizes and returns a value indicating whether
    one file size is greater than or less than the other.
  * `equals?/2` - Determines whether two file sizes are equal.
  * `lt?/2` - Determines whether file size a < b.
  * `lte?/2` - Determines whether file size a <= b.
  * `gt?/2` - Determines whether file size a > b.
  * `gte?/2` - Determines whether file size a >= b.

  To sort a collection of file sizes from smallest to greatest, you can use
  `lte?/2` as sort function. To sort descending use `gte?/2`.

      iex> sizes = [~F(16 GB), ~F(100 Mbit), ~F(27.4 MB), ~F(16 Gbit)]
      ...> Enum.sort(sizes, &FileSize.lte?/2)
      [#FileSize<"100.0 Mbit">, #FileSize<"27.4 MB">, #FileSize<"16.0 Gbit">, #FileSize<"16.0 GB">]

  ## Supported Units

  ### Bit-based

  #### SI (Système international d'unités)

  | Atom     | Symbol | Name       | Factor |
  |----------|--------|------------|--------|
  | `:bit`   | bit    | Bits       | 1      |
  | `:kbit`  | kbit   | Kilobits   | 1000   |
  | `:mbit`  | Mbit   | Megabits   | 1000^2 |
  | `:gbit`  | GBit   | Gigabits   | 1000^3 |
  | `:tbit`  | TBit   | Terabits   | 1000^4 |
  | `:pbit`  | PBit   | Petabits   | 1000^5 |
  | `:ebit`  | EBit   | Exabits    | 1000^6 |
  | `:zbit`  | ZBit   | Zetabits   | 1000^7 |
  | `:ybit`  | YBit   | Yottabits  | 1000^8 |

  #### IEC (International Electrotechnical Commission)

  | Atom     | Symbol | Name       | Factor |
  |----------|--------|------------|--------|
  | `:bit`   | Bit    | Bits       | 1      |
  | `:kibit` | Kibit  | Kibibits   | 1024   |
  | `:mibit` | Mibit  | Mebibits   | 1024^2 |
  | `:gibit` | Gibit  | Gibibits   | 1024^3 |
  | `:tibit` | Tibit  | Tebibits   | 1024^4 |
  | `:pibit` | Pibit  | Pebibits   | 1024^5 |
  | `:eibit` | Eibit  | Exbibits   | 1024^6 |
  | `:zibit` | Zibit  | Zebibits   | 1024^7 |
  | `:yibit` | Yibit  | Yobibits   | 1024^8 |

  ### Byte-based

  The most common unit of digital information. A single Byte represents 8 Bits.

  #### SI (Système international d'unités)

  | Atom     | Symbol | Name       | Factor |
  |----------|--------|------------|--------|
  | `:b`     | B      | Bytes      | 1      |
  | `:kb`    | kB     | Kilobytes  | 1000   |
  | `:mb`    | MB     | Megabytes  | 1000^2 |
  | `:gb`    | GB     | Gigabytes  | 1000^3 |
  | `:tb`    | TB     | Terabytes  | 1000^4 |
  | `:pb`    | PB     | Petabytes  | 1000^5 |
  | `:eb`    | EB     | Exabytes   | 1000^6 |
  | `:zb`    | ZB     | Zetabytes  | 1000^7 |
  | `:yb`    | YB     | Yottabytes | 1000^8 |

  #### IEC (International Electrotechnical Commission)

  | Atom     | Symbol | Name       | Factor |
  |----------|--------|------------|--------|
  | `:b`     | B      | Bytes      | 1      |
  | `:kib`   | KiB    | Kibibytes  | 1024   |
  | `:mib`   | MiB    | Mebibytes  | 1024^2 |
  | `:gib`   | GiB    | Gibibytes  | 1024^3 |
  | `:tib`   | TiB    | Tebibytes  | 1024^4 |
  | `:pib`   | PiB    | Pebibytes  | 1024^5 |
  | `:eib`   | EiB    | Exbibytes  | 1024^6 |
  | `:zib`   | ZiB    | Zebibytes  | 1024^7 |
  | `:yib`   | YiB    | Yobibytes  | 1024^8 |
  """

  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Calculable
  alias FileSize.Comparable
  alias FileSize.Convertible
  alias FileSize.Units
  alias FileSize.Units.Info, as: UnitInfo

  @typedoc """
  A type that defines the IEC bit and byte units.
  """
  @type iec_unit :: Bit.iec_unit() | Byte.iec_unit()

  @typedoc """
  A type that defines the SI bit and byte units.
  """
  @type si_unit :: Bit.si_unit() | Byte.si_unit()

  @typedoc """
  A type that is a union of the bit and byte types.
  """
  @type t :: Bit.t() | Byte.t()

  @typedoc """
  A type that is a union of the bit and byte unit types and
  `t:FileSize.Units.Info.t/0`.
  """
  @type unit :: iec_unit | si_unit | UnitInfo.t() | unit_symbol

  @typedoc """
  A type that represents a unit symbol.
  """
  @type unit_symbol :: String.t()

  @typedoc """
  A type that contains the available unit systems.
  """
  @type unit_system :: :iec | :si

  @typedoc """
  A type that defines the value used to create a new file size.
  """
  @type value :: number | String.t() | Decimal.t()

  @doc false
  defmacro __using__(_) do
    quote do
      import FileSize.Sigil
    end
  end

  @doc """
  Gets the configuration.
  """
  @spec __config__() :: Keyword.t()
  def __config__ do
    Application.get_all_env(:file_size)
  end

  @doc """
  Builds a new file size. Raises when the given unit could not be found.

  ## Examples

      iex> FileSize.new(2.5, :mb)
      #FileSize<"2.5 MB">

      iex> FileSize.new(214, :kib)
      #FileSize<"214 KiB">

      iex> FileSize.new(3, :bit)
      #FileSize<"3 bit">

      iex> FileSize.new("214", "KiB")
      #FileSize<"214 KiB">
  """
  @spec new(value, unit) :: t | no_return
  def new(value, symbol_or_unit_or_unit_info \\ :b)

  def new(value, %UnitInfo{mod: mod} = unit_info) do
    mod.new(value, unit_info)
  end

  def new(value, symbol_or_unit) do
    new(value, Units.fetch!(symbol_or_unit))
  end

  @doc """
  Builds a new file size from the given number of bits.

  ## Example

      iex> FileSize.from_bytes(2000)
      #FileSize<"2000 B">
  """
  @spec from_bytes(value) :: t
  def from_bytes(bytes), do: FileSize.new(bytes, :b)

  @doc """
  Builds a new file size from the given number of bits, allowing conversion
  in the same step.

  ## Options

  When a keyword list is given, you must specify one of the following options.

  * `:convert` - Converts the file size to the given `t:unit/0`.
  * `:scale` - Scales and converts the file size to an appropriate unit in the
    specified `t:unit_system/0`.

  ## Examples

      iex> FileSize.from_bytes(2000, scale: :iec)
      #FileSize<"1.953125 KiB">

      iex> FileSize.from_bytes(16, scale: :unknown)
      ** (FileSize.InvalidUnitSystemError) Invalid unit system: :unknown

      iex> FileSize.from_bytes(2, convert: :bit)
      #FileSize<"16 bit">

      iex> FileSize.from_bytes(1600, :kb)
      #FileSize<"1.6 kB">

      iex> FileSize.from_bytes(16, convert: :unknown)
      ** (FileSize.InvalidUnitError) Invalid unit: :unknown
  """
  @spec from_bytes(value, unit | Keyword.t()) :: t
  def from_bytes(bytes, symbol_or_unit_or_unit_info_or_opts)

  def from_bytes(bytes, opts) when is_list(opts) do
    do_from_bytes(bytes, opts)
  end

  def from_bytes(bytes, unit_or_unit_info) do
    do_from_bytes(bytes, convert: unit_or_unit_info)
  end

  defp do_from_bytes(bytes, convert: unit_or_unit_info) do
    bytes
    |> from_bytes()
    |> convert(unit_or_unit_info)
  end

  defp do_from_bytes(bytes, scale: unit_system) do
    bytes
    |> from_bytes()
    |> scale(unit_system)
  end

  @doc """
  Builds a new file size from the given number of bits.

  ## Example

      iex> FileSize.from_bits(2000)
      #FileSize<"2000 bit">
  """
  @spec from_bits(value) :: t
  def from_bits(bits), do: FileSize.new(bits, :bit)

  @doc """
  Builds a new file size from the given number of bits, allowing conversion
  in the same step.

  ## Options

  When a keyword list is given, you must specify one of the following options.

  * `:convert` - Converts the file size to the given `t:unit/0`.
  * `:scale` - Scales and converts the file size to an appropriate unit in the
    specified `t:unit_system/0`.

  ## Examples

      iex> FileSize.from_bits(2000, scale: :iec)
      #FileSize<"1.953125 Kibit">

      iex> FileSize.from_bits(16, scale: :unknown)
      ** (FileSize.InvalidUnitSystemError) Invalid unit system: :unknown

      iex> FileSize.from_bits(16, convert: :b)
      #FileSize<"2 B">

      iex> FileSize.from_bits(1600, :kbit)
      #FileSize<"1.6 kbit">

      iex> FileSize.from_bits(16, convert: :unknown)
      ** (FileSize.InvalidUnitError) Invalid unit: :unknown
  """
  @spec from_bits(value, unit | Keyword.t()) :: t
  def from_bits(bits, symbol_or_unit_or_unit_info_or_opts)

  def from_bits(bits, opts) when is_list(opts) do
    do_from_bits(bits, opts)
  end

  def from_bits(bits, unit_or_unit_info) do
    do_from_bits(bits, convert: unit_or_unit_info)
  end

  defp do_from_bits(bits, convert: unit_or_unit_info) do
    bits
    |> from_bits()
    |> convert(unit_or_unit_info)
  end

  defp do_from_bits(bits, scale: unit_system) do
    bits
    |> from_bits()
    |> scale(unit_system)
  end

  @doc """
  Determines the size of the file at the given path.

  ## Options

  When a keyword list is given, you must specify one of the following options.

  * `:convert` - Converts the file size to the given `t:unit/0`.
  * `:scale` - Scales and converts the file size to an appropriate unit in the
    specified `t:unit_system/0`.

  ## Examples

      iex> FileSize.from_file("path/to/my/file.txt")
      {:ok, #FileSize<"133.7 kB">}

      iex> FileSize.from_file("path/to/my/file.txt", :mb)
      {:ok, #FileSize<"0.13 MB">}

      iex> FileSize.from_file("path/to/my/file.txt", unit: :mb)
      {:ok, #FileSize<"0.13 MB">}

      iex> FileSize.from_file("path/to/my/file.txt", scale: :iec)
      {:ok, #FileSize<"133.7 KiB">}

      iex> FileSize.from_file("not/existing/file.txt")
      {:error, :enoent}
  """
  @spec from_file(Path.t(), unit | Keyword.t()) ::
          {:ok, t} | {:error, File.posix()}
  def from_file(path, symbol_or_unit_or_unit_info_or_opts \\ :b) do
    with {:ok, %{size: value}} <- File.stat(path) do
      {:ok, from_bytes(value, symbol_or_unit_or_unit_info_or_opts)}
    end
  end

  @doc """
  Determines the size of the file at the given path. Raises when the file could
  not be found.

  ## Options

  When a keyword list is given, you must specify one of the following options.

  * `:convert` - Converts the file size to the given `t:unit/0`.
  * `:scale` - Scales and converts the file size to an appropriate unit in the
    specified `t:unit_system/0`.

  ## Examples

      iex> FileSize.from_file!("path/to/my/file.txt")
      #FileSize<"133.7 kB">

      iex> FileSize.from_file!("path/to/my/file.txt", :mb)
      #FileSize<"0.13 MB">

      iex> FileSize.from_file!("path/to/my/file.txt", unit: :mb)
      #FileSize<"0.13 MB">

      iex> FileSize.from_file!("path/to/my/file.txt", unit: "KiB")
      #FileSize<"133.7 KiB">

      iex> FileSize.from_file!("path/to/my/file.txt", system: :iec)
      #FileSize<"133.7 KiB">

      iex> FileSize.from_file!("not/existing/file.txt")
      ** (File.Error) could not read file stats "not/existing/file.txt": no such file or directory
  """
  @spec from_file!(Path.t(), unit | Keyword.t()) ::
          t | no_return
  def from_file!(path, symbol_or_unit_or_unit_info_or_opts \\ :b) do
    path
    |> File.stat!()
    |> Map.fetch!(:size)
    |> from_bytes(symbol_or_unit_or_unit_info_or_opts)
  end

  @doc """
  Converts the given value into a value of type `t:FileSize.t/0`. Returns a
  tuple containing the status and value or error.
  """
  @spec parse(any) :: {:ok, t} | {:error, FileSize.ParseError.t()}
  defdelegate parse(value), to: FileSize.Parser

  @doc """
  Converts the given value into a value of type `t:FileSize.t/0`. Returns the
  value on success or raises `FileSize.ParseError` on error.
  """
  @spec parse!(any) :: t | no_return
  defdelegate parse!(value), to: FileSize.Parser

  @doc """
  Formats a file size in a human-readable format, allowing customization of the
  formatting.

  ## Options

  * `:symbols` - Allows using your own unit symbols. Must be a map that contains
    the unit names as keys (as defined by `t:FileSize.unit/0`) and the unit
    symbol strings as values. Missing entries in the map are filled with the
    internal unit symbols from `FileSize.Units.list/0`.

  Other options customize the number format and are forwarded to
  `Number.Delimit.number_to_delimited/2`. The default precision for numbers is
  0.

  ## Global Configuration

  You can also define your custom symbols globally.

      config :file_size, :symbols, %{b: "Byte", kb: "KB"}

  The same is possible for number formatting.

      config :file_size, :number_format, precision: 2, delimiter: ",", separator: "."

  Or globally for the number library.

      config :number, delimit: [precision: 2, delimiter: ",", separator: "."]

  ## Examples

      iex> FileSize.format(FileSize.new(32, :kb))
      "32 kB"

      iex> FileSize.format(FileSize.new(2048.2, :mb))
      "2,048 MB"
  """
  @spec format(t, Keyword.t()) :: String.t()
  defdelegate format(size, opts \\ []), to: FileSize.Formatter

  @doc """
  Formats the given size ignoring all user configuration. The result of this
  function can be passed back to `FileSize.parse/1` and is also used by the
  implementations of the `Inspect` and `String.Chars` protocols.

  ## Example

      iex> FileSize.to_string(FileSize.new(32.2, :kb))
      "32.2 kB"
  """
  @spec to_string(t) :: String.t()
  defdelegate to_string(size), to: FileSize.Formatter, as: :format_simple

  @doc """
  Converts the given file size to a given unit or unit system.

  ## Options

  When a keyword list is given, you must specify one of the following options.

  * `:unit` - Converts the file size to the given `t:unit/0`.
  * `:system` - Converts the file size to the given `t:unit_system/0`.

  ## Examples

      iex> FileSize.convert(FileSize.new(2, :kb), :b)
      #FileSize<"2000 B">

      iex> FileSize.convert(FileSize.new(2000, :b), unit: :kb)
      #FileSize<"2 kB">

      iex> FileSize.convert(FileSize.new(20, :kb), :kbit)
      #FileSize<"160 kbit">

      iex> FileSize.convert(FileSize.new(2, :kb), system: :iec)
      #FileSize<"1.953125 KiB">

      iex> FileSize.convert(FileSize.new(2, :kib), system: :si)
      #FileSize<"2.048 kB">

      iex> FileSize.convert(FileSize.new(2000, :b), unit: :unknown)
      ** (FileSize.InvalidUnitError) Invalid unit: :unknown

      iex> FileSize.convert(FileSize.new(2, :b), system: :unknown)
      ** (FileSize.InvalidUnitSystemError) Invalid unit system: :unknown
  """
  @spec convert(t, unit | Keyword.t()) :: t
  def convert(size, symbol_or_unit_or_unit_info_or_opts)

  def convert(size, opts) when is_list(opts) do
    do_convert(size, opts)
  end

  def convert(size, unit_or_unit_info) do
    do_convert(size, unit: unit_or_unit_info)
  end

  defp do_convert(size, unit: unit) do
    Convertible.convert(size, Units.fetch!(unit))
  end

  defp do_convert(size, system: unit_system) do
    convert(size, Units.equivalent_unit_for_system!(size.unit, unit_system))
  end

  @doc """
  Converts the given file size to the most appropriate unit. When no unit system
  is specified, the unit system of the source file size is used. If no unit
  system could be inferred from the size, the SI unit system is used.

  ## Examples

      iex> FileSize.scale(FileSize.new(2000, :b))
      #FileSize<"2 kB">

      iex> FileSize.scale(FileSize.new(2_000_000, :kb))
      #FileSize<"2 GB">

      iex> FileSize.scale(FileSize.new(2_000_000, :kb), :iec)
      #FileSize<"1.862645149230957 GiB">

      iex> FileSize.scale(FileSize.new(2000, :b), :unknown)
      ** (FileSize.InvalidUnitSystemError) Invalid unit system: :unknown
  """
  @doc since: "1.1.0"
  @spec scale(t, nil | unit_system) :: t
  def scale(size, unit_system \\ nil) do
    convert(size, Units.appropriate_unit_for_size!(size, unit_system))
  end

  defdelegate compare(size, other_size), to: Comparable

  @doc """
  Determines whether two file sizes are equal.

  ## Examples

      iex> FileSize.equals?(FileSize.new(2, :b), FileSize.new(16, :bit))
      true

      iex> FileSize.equals?(FileSize.new(2, :b), FileSize.new(2, :b))
      true

      iex> FileSize.equals?(FileSize.new(1, :b), FileSize.new(2, :b))
      false
  """
  @spec equals?(t, t) :: boolean
  def equals?(size, other_size) do
    compare(size, other_size) == :eq
  end

  @doc """
  Determines whether the first file size is less than the second one.

  ## Examples

      iex> FileSize.lt?(FileSize.new(1, :b), FileSize.new(2, :b))
      true

      iex> FileSize.lt?(FileSize.new(2, :b), FileSize.new(1, :b))
      false
  """
  @doc since: "1.2.0"
  @spec lt?(t, t) :: boolean
  def lt?(size, other_size) do
    compare(size, other_size) == :lt
  end

  @doc """
  Determines whether the first file size is less or equal to than the second
  one.

  ## Examples

      iex> FileSize.lte?(FileSize.new(1, :b), FileSize.new(2, :b))
      true

      iex> FileSize.lte?(FileSize.new(1, :b), FileSize.new(1, :b))
      true

      iex> FileSize.lte?(FileSize.new(2, :b), FileSize.new(1, :b))
      false
  """
  @doc since: "2.0.0"
  @spec lte?(t, t) :: boolean
  def lte?(size, other_size) do
    compare(size, other_size) in [:lt, :eq]
  end

  @doc """
  Determines whether the first file size is greater than the second one.

  ## Examples

      iex> FileSize.gt?(FileSize.new(2, :b), FileSize.new(1, :b))
      true

      iex> FileSize.gt?(FileSize.new(1, :b), FileSize.new(2, :b))
      false
  """
  @doc since: "1.2.0"
  @spec gt?(t, t) :: boolean
  def gt?(size, other_size) do
    compare(size, other_size) == :gt
  end

  @doc """
  Determines whether the first file size is less or equal to than the second
  one.

  ## Examples

      iex> FileSize.gte?(FileSize.new(2, :b), FileSize.new(1, :b))
      true

      iex> FileSize.gte?(FileSize.new(1, :b), FileSize.new(1, :b))
      true

      iex> FileSize.gte?(FileSize.new(1, :b), FileSize.new(2, :b))
      false
  """
  @doc since: "2.0.0"
  @spec gte?(t, t) :: boolean
  def gte?(size, other_size) do
    compare(size, other_size) in [:eq, :gt]
  end

  defdelegate add(size, other_size), to: Calculable

  @doc """
  Adds two file sizes like `add/2` and converts the result to the specified
  unit.

  ## Options

  When a keyword list is given, you must specify one of the following options.

  * `:unit` - Converts the file size to the given `t:unit/0`.
  * `:system` - Converts the file size to the given `t:unit_system/0`.

  ## Examples

      iex> FileSize.add(FileSize.new(1, :kb), FileSize.new(2, :kb), :b)
      #FileSize<"3000 B">

      iex> FileSize.add(FileSize.new(1, :kb), FileSize.new(2, :kb), unit: :b)
      #FileSize<"3000 B">

      iex> FileSize.add(FileSize.new(1, :kb), FileSize.new(2, :kb), system: :iec)
      #FileSize<"2.9296875 KiB">
  """
  @spec add(t, t, unit | Keyword.t()) :: t
  def add(size, other_size, symbol_or_unit_or_unit_info_or_opts) do
    size
    |> add(other_size)
    |> convert(symbol_or_unit_or_unit_info_or_opts)
  end

  defdelegate subtract(size, other_size), to: Calculable

  @doc """
  Subtracts two file sizes like `subtract/2` and converts the result to the
  specified unit.

  ## Options

  When a keyword list is given, you must specify one of the following options.

  * `:unit` - Converts the file size to the given `t:unit/0`.
  * `:system` - Converts the file size to the given `t:unit_system/0`.

  ## Examples

      iex> FileSize.subtract(FileSize.new(2, :b), FileSize.new(6, :bit), :bit)
      #FileSize<"10 bit">

      iex> FileSize.subtract(FileSize.new(2, :b), FileSize.new(6, :bit), unit: :bit)
      #FileSize<"10 bit">

      iex> FileSize.subtract(FileSize.new(3, :kb), FileSize.new(1, :kb), system: :iec)
      #FileSize<"1.953125 KiB">
  """
  @spec subtract(t, t, unit | Keyword.t()) :: t
  def subtract(size, other_size, symbol_or_unit_or_unit_info_or_opts) do
    size
    |> subtract(other_size)
    |> convert(symbol_or_unit_or_unit_info_or_opts)
  end

  @doc """
  Gets the normalized size from the given file size as integer.

  ## Example

      iex> FileSize.to_integer(FileSize.new(2, :kbit))
      2000
  """
  @doc since: "2.0.0"
  @spec to_integer(t) :: integer
  def to_integer(size) do
    size
    |> Convertible.normalized_value()
    |> trunc()
  end

  @doc """
  Gets the value from the file size as float.

  ## Examples

      iex> FileSize.value_to_float(FileSize.new(2, :kbit))
      2.0

      iex> FileSize.value_to_float(FileSize.new(2.3, :kbit))
      2.3
  """
  @doc since: "2.1.0"
  @spec value_to_float(t) :: float
  def value_to_float(size) do
    size.value / 1
  end
end

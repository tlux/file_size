defmodule FileSize do
  @moduledoc """
  A file size calculator, parser and formatter.

  ## Usage

  You can build your own file size by creating it with a number and a unit using
  the `new/2` function. See the "Supported Units" section for a list of possible
  unit atoms.

      iex> FileSize.new(16, :gb)
      #FileSize<"16.0 GB">

  ### Sigil

  There is also a sigil defined that you can use to quickly build file sizes
  from a number and unit symbol. Just import the `FileSize.Sigil` module and you
  are ready to go. See the "Supported Units" section for a list of possible
  unit symbols.

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

  For comparison the particular units don't need to be the same.

  * `compare/2` - Compares two file sizes and returns a value indicating whether
    one file size is greater than or less than the other.
  * `equals?/2` - Determines whether two file sizes are equal.

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
  alias FileSize.Formatter
  alias FileSize.Parser
  alias FileSize.Units

  @typedoc """
  A type that defines the IEC bit and byte units.
  """
  @type iec_unit :: Bit.iec_unit() | Byte.iec_unit()

  @typedoc """
  A type that defines the SI bit and byte units.
  """
  @type si_unit :: Bit.si_unit() | Byte.si_unit()

  @typedoc """
  A type that is a union of the bit and byte unit types.
  """
  @type unit :: iec_unit | si_unit

  @typedoc """
  A type that contains the available unit systems.
  """
  @type unit_system :: :iec | :si

  @typedoc """
  A type that represents a unit symbol.
  """
  @type unit_symbol :: String.t()

  @typedoc """
  A type that is a union of the bit and byte types.
  """
  @type t :: Bit.t() | Byte.t()

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
      #FileSize<"214.0 KiB">

      iex> FileSize.new(3, :bit)
      #FileSize<"3 bit">
  """
  @spec new(number, unit) :: t | no_return
  def new(value, unit \\ :b) do
    denormalized_value = sanitize_denormalized_value(value)
    info = Units.unit_info!(unit)
    normalized_value = Units.normalize_value(value, info)

    info.mod
    |> struct(value: denormalized_value, unit: unit)
    |> Convertible.new(normalized_value)
  end

  defp sanitize_denormalized_value(value) when is_integer(value), do: value / 1

  defp sanitize_denormalized_value(value) when is_float(value), do: value

  defp sanitize_denormalized_value(value) do
    raise ArgumentError,
          "Value must be integer or float (but #{inspect(value)} given)"
  end

  @doc """
  Builds a new file size from the given number of bytes.

  ## Example

      iex> FileSize.from_bytes(2000)
      #FileSize<"2.0 kB">

      iex> FileSize.from_bytes(2000, {:system, :iec})
      #FileSize<"1.953125 KiB">

      iex> FileSize.from_bytes(2000, :kb)
      #FileSize<"2.0 kB">

      iex> FileSize.from_bytes(2000, :kbit)
      #FileSize<"16.0 kbit">

      iex> FileSize.from_bytes(2000, :unknown)
      ** (FileSize.InvalidUnitError) Invalid unit: :unknown
  """
  @spec from_bytes(integer, unit | {:system, unit_system}) :: t
  def from_bytes(bytes, as_unit_or_unit_system \\ {:system, :si})

  def from_bytes(bytes, {:system, as_unit_system}) do
    bytes |> new(:b) |> scale(as_unit_system)
  end

  def from_bytes(bytes, as_unit) do
    bytes |> new(:b) |> convert(as_unit)
  end

  @doc """
  Builds a new file size from the given number of bits.

  ## Example

      iex> FileSize.from_bits(2000)
      #FileSize<"2.0 kbit">

      iex> FileSize.from_bits(2000, {:system, :iec})
      #FileSize<"1.953125 Kibit">

      iex> FileSize.from_bits(16, :b)
      #FileSize<"2 B">

      iex> FileSize.from_bits(16, :unknown)
      ** (FileSize.InvalidUnitError) Invalid unit: :unknown
  """
  @spec from_bits(integer, unit | {:system, unit_system}) :: t
  def from_bits(bytes, as_unit_or_unit_system \\ {:system, :si})

  def from_bits(bits, {:system, as_unit_system}) do
    bits |> new(:bit) |> scale(as_unit_system)
  end

  def from_bits(bits, as_unit) do
    bits |> new(:bit) |> convert(as_unit)
  end

  @doc """
  Determines the size of the file at the given path.

  ## Examples

      iex> FileSize.from_file("path/to/my/file.txt")
      {:ok, #FileSize<"133.7 kB">}

      iex> FileSize.from_file("path/to/my/file.txt", {:system, :iec})
      {:ok, #FileSize<"133.7 KiB">}

      iex> FileSize.from_file("path/to/my/file.txt", :mb)
      {:ok, #FileSize<"0.13 MB">}

      iex> FileSize.from_file("not/existing/file.txt")
      {:error, :enoent}
  """
  @spec from_file(Path.t(), unit | {:system, unit_system}) ::
          {:ok, t} | {:error, File.posix()}
  def from_file(path, as_unit_or_unit_system \\ :b) do
    with {:ok, %{size: value}} <- File.stat(path) do
      {:ok, from_bytes(value, as_unit_or_unit_system)}
    end
  end

  @doc """
  Determines the size of the file at the given path. Raises when the file could
  not be found.

  ## Examples

      iex> FileSize.from_file!("path/to/my/file.txt")
      #FileSize<"133.7 kB">

      iex> FileSize.from_file!("path/to/my/file.txt", {:system, :iec})
      #FileSize<"133.7 KiB">

      iex> FileSize.from_file!("path/to/my/file.txt", :mb)
      #FileSize<"0.13 MB">

      iex> FileSize.from_file!("not/existing/file.txt")
      ** (File.Error) could not read file stats "not/existing/file.txt": no such file or directory
  """
  @spec from_file!(Path.t(), unit | {:system, unit_system}) :: t | no_return
  def from_file!(path, as_unit_or_unit_system \\ :b) do
    path
    |> File.stat!()
    |> Map.fetch!(:size)
    |> from_bytes(as_unit_or_unit_system)
  end

  defdelegate parse(value), to: Parser
  defdelegate parse!(value), to: Parser
  defdelegate format(size, opts \\ []), to: Formatter

  @doc """
  Converts the given file size to a given unit or unit system.

  ## Examples

      iex> FileSize.convert(FileSize.new(2, :kb), :b)
      #FileSize<"2000 B">

      iex> FileSize.convert(FileSize.new(2000, :b), :kb)
      #FileSize<"2.0 kB">

      iex> FileSize.convert(FileSize.new(20, :kb), :kbit)
      #FileSize<"160.0 kbit">

      iex> FileSize.convert(FileSize.new(2, :kb), {:system, :iec})
      #FileSize<"1.953125 KiB">

      iex> FileSize.convert(FileSize.new(2, :kib), {:system, :si})
      #FileSize<"2.048 kB">

      iex> FileSize.convert(FileSize.new(2000, :b), :unknown)
      ** (FileSize.InvalidUnitError) Invalid unit: :unknown

      iex> FileSize.convert(FileSize.new(2, :b), {:system, :unknown})
      ** (FileSize.InvalidUnitSystemError) Invalid unit system: :unknown
  """
  def convert(size, to_unit_or_unit_system)

  def convert(size, {:system, to_unit_system}) do
    to_unit = Units.equivalent_unit_for_system!(size.unit, to_unit_system)
    Convertible.convert(size, to_unit)
  end

  def convert(size, to_unit) do
    Convertible.convert(size, to_unit)
  end

  @doc """
  Converts the given file size to a given unit system.
  """
  @deprecated "Use convert/2 instead"
  @spec change_unit_system(t, unit_system) :: t
  def change_unit_system(size, unit_system) do
    convert(size, Units.equivalent_unit_for_system!(size.unit, unit_system))
  end

  @doc """
  Converts the given file size to the most appropriate unit.

  ## Examples

      iex> FileSize.scale(FileSize.new(2000, :b))
      #FileSize<"2.0 kB">

      iex> FileSize.scale(FileSize.new(2_000_000, :kb))
      #FileSize<"2.0 GB">
  """
  @doc since: "1.1.0"
  @spec scale(t, nil | unit_system) :: t
  def scale(size, unit_system \\ nil) do
    convert(size, Units.appropriate_unit_for_size(size, unit_system))
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
    compare(size, other_size) == 0
  end

  defdelegate add(size, other_size), to: Calculable

  @doc """
  Adds two file sizes like `add/2` and converts the result to the specified
  unit.

  ## Example

      iex> FileSize.add(FileSize.new(1, :kb), FileSize.new(2, :kb), :b)
      #FileSize<"3000 B">
  """
  @spec add(t, t, unit) :: t
  def add(size, other_size, as_unit) do
    size |> add(other_size) |> convert(as_unit)
  end

  defdelegate subtract(size, other_size), to: Calculable

  @doc """
  Subtracts two file sizes like `subtract/2` and converts the result to the
  specified unit.

  ## Example

      iex> FileSize.subtract(FileSize.new(2, :b), FileSize.new(6, :bit), :bit)
      #FileSize<"10 bit">
  """
  @spec subtract(t, t, unit) :: t
  def subtract(size, other_size, as_unit) do
    size |> subtract(other_size) |> convert(as_unit)
  end
end

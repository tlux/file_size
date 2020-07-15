defmodule FileSize.Units do
  @moduledoc """
  A module to retrieve information about known units.
  """

  alias FileSize.Convertible
  alias FileSize.InvalidUnitError
  alias FileSize.InvalidUnitSystemError
  alias FileSize.Units.Info

  @unit_systems [:si, :iec]

  @units [
    # Bit
    Info.new(name: :bit, mod: FileSize.Bit, exp: 0, system: nil, symbol: "bit"),
    Info.new(
      name: :kbit,
      mod: FileSize.Bit,
      exp: 1,
      system: :si,
      symbol: "kbit"
    ),
    Info.new(
      name: :kibit,
      mod: FileSize.Bit,
      exp: 1,
      system: :iec,
      symbol: "Kibit"
    ),
    Info.new(
      name: :mbit,
      mod: FileSize.Bit,
      exp: 2,
      system: :si,
      symbol: "Mbit"
    ),
    Info.new(
      name: :mibit,
      mod: FileSize.Bit,
      exp: 2,
      system: :iec,
      symbol: "Mibit"
    ),
    Info.new(
      name: :gbit,
      mod: FileSize.Bit,
      exp: 3,
      system: :si,
      symbol: "Gbit"
    ),
    Info.new(
      name: :gibit,
      mod: FileSize.Bit,
      exp: 3,
      system: :iec,
      symbol: "Gibit"
    ),
    Info.new(
      name: :tbit,
      mod: FileSize.Bit,
      exp: 4,
      system: :si,
      symbol: "Tbit"
    ),
    Info.new(
      name: :tibit,
      mod: FileSize.Bit,
      exp: 4,
      system: :iec,
      symbol: "Tibit"
    ),
    Info.new(
      name: :pbit,
      mod: FileSize.Bit,
      exp: 5,
      system: :si,
      symbol: "Pbit"
    ),
    Info.new(
      name: :pibit,
      mod: FileSize.Bit,
      exp: 5,
      system: :iec,
      symbol: "Pibit"
    ),
    Info.new(
      name: :ebit,
      mod: FileSize.Bit,
      exp: 6,
      system: :si,
      symbol: "Ebit"
    ),
    Info.new(
      name: :eibit,
      mod: FileSize.Bit,
      exp: 6,
      system: :iec,
      symbol: "Eibit"
    ),
    Info.new(
      name: :ebit,
      mod: FileSize.Bit,
      exp: 6,
      system: :si,
      symbol: "Ebit"
    ),
    Info.new(
      name: :eibit,
      mod: FileSize.Bit,
      exp: 6,
      system: :iec,
      symbol: "Eibit"
    ),
    Info.new(
      name: :zbit,
      mod: FileSize.Bit,
      exp: 7,
      system: :si,
      symbol: "Zbit"
    ),
    Info.new(
      name: :zibit,
      mod: FileSize.Bit,
      exp: 7,
      system: :iec,
      symbol: "Zibit"
    ),
    Info.new(
      name: :ybit,
      mod: FileSize.Bit,
      exp: 8,
      system: :si,
      symbol: "Ybit"
    ),
    Info.new(
      name: :yibit,
      mod: FileSize.Bit,
      exp: 8,
      system: :iec,
      symbol: "Yibit"
    ),
    # Byte
    Info.new(name: :b, mod: FileSize.Byte, exp: 0, system: nil, symbol: "B"),
    Info.new(name: :kb, mod: FileSize.Byte, exp: 1, system: :si, symbol: "kB"),
    Info.new(
      name: :kib,
      mod: FileSize.Byte,
      exp: 1,
      system: :iec,
      symbol: "KiB"
    ),
    Info.new(name: :mb, mod: FileSize.Byte, exp: 2, system: :si, symbol: "MB"),
    Info.new(
      name: :mib,
      mod: FileSize.Byte,
      exp: 2,
      system: :iec,
      symbol: "MiB"
    ),
    Info.new(name: :gb, mod: FileSize.Byte, exp: 3, system: :si, symbol: "GB"),
    Info.new(
      name: :gib,
      mod: FileSize.Byte,
      exp: 3,
      system: :iec,
      symbol: "GiB"
    ),
    Info.new(name: :tb, mod: FileSize.Byte, exp: 4, system: :si, symbol: "TB"),
    Info.new(
      name: :tib,
      mod: FileSize.Byte,
      exp: 4,
      system: :iec,
      symbol: "TiB"
    ),
    Info.new(name: :pb, mod: FileSize.Byte, exp: 5, system: :si, symbol: "PB"),
    Info.new(
      name: :pib,
      mod: FileSize.Byte,
      exp: 5,
      system: :iec,
      symbol: "PiB"
    ),
    Info.new(name: :eb, mod: FileSize.Byte, exp: 6, system: :si, symbol: "EB"),
    Info.new(
      name: :eib,
      mod: FileSize.Byte,
      exp: 6,
      system: :iec,
      symbol: "EiB"
    ),
    Info.new(name: :zb, mod: FileSize.Byte, exp: 7, system: :si, symbol: "ZB"),
    Info.new(
      name: :zib,
      mod: FileSize.Byte,
      exp: 7,
      system: :iec,
      symbol: "ZiB"
    ),
    Info.new(name: :yb, mod: FileSize.Byte, exp: 8, system: :si, symbol: "YB"),
    Info.new(
      name: :yib,
      mod: FileSize.Byte,
      exp: 8,
      system: :iec,
      symbol: "YiB"
    )
  ]

  @units_by_names Map.new(@units, fn unit -> {unit.name, unit} end)
  @units_by_symbols Map.new(@units, fn unit -> {unit.symbol, unit} end)

  @units_by_mods_and_systems_and_exps Map.new(@units, fn info ->
                                        {{info.mod, info.system, info.exp},
                                         info}
                                      end)

  @doc """
  Gets a list of all defined units.
  """
  @doc since: "2.0.0"
  @spec list() :: [Info.t()]
  def list, do: @units

  @doc """
  Gets unit info for the unit specified by the given name.
  """
  @doc since: "2.0.0"
  @spec fetch(FileSize.unit()) :: {:ok, Info.t()} | :error
  def fetch(symbol_unit_or_unit_info)

  def fetch(%Info{} = unit), do: {:ok, unit}

  def fetch(unit) when is_atom(unit) do
    Map.fetch(@units_by_names, unit)
  end

  def fetch(symbol) when is_binary(symbol), do: from_symbol(symbol)

  def fetch(_), do: :error

  @doc """
  Gets unit info for the unit specified by the given name. Raises when the unit
  with the given name is unknown.
  """
  @doc since: "2.0.0"
  @spec fetch!(FileSize.unit()) :: Info.t() | no_return
  def fetch!(unit) do
    case fetch(unit) do
      {:ok, info} -> info
      :error -> raise InvalidUnitError, unit: unit
    end
  end

  @doc false
  @spec from_symbol(FileSize.unit_symbol()) :: {:ok, Info.t()} | :error
  def from_symbol(symbol) do
    Map.fetch(@units_by_symbols, symbol)
  end

  @doc false
  @spec equivalent_unit_for_system!(FileSize.unit(), FileSize.unit_system()) ::
          Info.t() | no_return
  def equivalent_unit_for_system!(symbol_or_unit_or_unit_info, unit_system)

  def equivalent_unit_for_system!(%Info{} = info, unit_system) do
    validate_unit_system!(unit_system)
    find_equivalent_unit_for_system(info, unit_system)
  end

  def equivalent_unit_for_system!(symbol_or_unit, unit_system) do
    symbol_or_unit
    |> fetch!()
    |> equivalent_unit_for_system!(unit_system)
  end

  defp find_equivalent_unit_for_system(%{system: nil} = info, _), do: info

  defp find_equivalent_unit_for_system(
         %{system: unit_system} = info,
         unit_system
       ) do
    info
  end

  defp find_equivalent_unit_for_system(info, unit_system) do
    Map.fetch!(
      @units_by_mods_and_systems_and_exps,
      {info.mod, unit_system, info.exp}
    )
  end

  @doc false
  @spec appropriate_unit_for_size!(FileSize.t(), nil | FileSize.unit_system()) ::
          Info.t() | no_return
  def appropriate_unit_for_size!(size, unit_system \\ nil) do
    value = Convertible.normalized_value(size)
    %{mod: mod} = orig_info = fetch!(size.unit)
    unit_system = unit_system || orig_info.system || :si
    validate_unit_system!(unit_system)

    Enum.find_value(@units, orig_info, fn
      %{mod: ^mod, system: ^unit_system} = info ->
        if value >= info.min_value && value <= info.max_value, do: info

      _ ->
        nil
    end)
  end

  defp validate_unit_system!(unit_system) when unit_system in @unit_systems do
    :ok
  end

  defp validate_unit_system!(unit_system) do
    raise InvalidUnitSystemError, unit_system: unit_system
  end
end

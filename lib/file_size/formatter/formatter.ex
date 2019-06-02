defmodule FileSize.Formatter do
  @moduledoc """
  A module that provides functions to convert file sizes to human-readable
  strings.
  """

  alias FileSize.Units

  import Number.Delimit, only: [number_to_delimited: 2]

  @doc """
  Formats a file size in a human-readable format, allowing customization of the
  formatting.

  ## Options

  * `:symbols` - Allows using your own unit symbols. Must be a map that contains
    the unit names as keys (as defined by `t:FileSize.unit/0`) and the unit
    symbol strings as values. Missing entries in the map are filled with the
    internal unit symbols from `FileSize.Units.unit_infos/0`.

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
  """
  @spec format(FileSize.t(), Keyword.t()) :: String.t()
  def format(size, opts \\ []) do
    {symbols, number_opts} = Keyword.pop(opts, :symbols, %{})
    value = format_number(size.value, number_opts)
    symbol = format_unit(size.unit, symbols)
    "#{value} #{symbol}"
  end

  @doc """
  Formats the given size ignoring all user configuration. The result of this
  function can be passed back to `FileSize.parse/1` and is also used by the
  implementations of the `Inspect` and `String.Chars` protocols.
  """
  @spec format_simple(FileSize.t()) :: String.t()
  def format_simple(size) do
    unit_info = Units.fetch!(size.unit)
    value = sanitize_value(size.value, unit_info.exp)
    "#{value} #{unit_info.symbol}"
  end

  defp sanitize_value(value, 0), do: trunc(value)
  defp sanitize_value(value, _), do: value

  defp format_number(value, opts) do
    opts =
      [precision: 0]
      |> Keyword.merge(number_opts_from_config())
      |> Keyword.merge(opts)

    number_to_delimited(value, opts)
  end

  defp format_unit(unit, symbols) do
    symbols[unit] || symbol_from_config(unit) || symbol_from_unit_info(unit)
  end

  defp number_opts_from_config do
    Keyword.merge(
      Application.get_env(:number, :delimit, []),
      Keyword.get(FileSize.__config__(), :number_format, [])
    )
  end

  defp symbol_from_config(unit) do
    FileSize.__config__()
    |> Keyword.get(:symbols, %{})
    |> Map.get(unit)
  end

  defp symbol_from_unit_info(unit) do
    unit
    |> Units.fetch!()
    |> Map.fetch!(:symbol)
  end
end

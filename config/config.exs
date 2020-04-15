# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :file_size, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:file_size, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

config :file_size,
  unit_systems: %{si: 1000, iec: 1024},
  units: [
    # Bit
    %{name: :bit, mod: FileSize.Bit, exp: 0, system: nil, symbol: "bit"},
    %{name: :kbit, mod: FileSize.Bit, exp: 1, system: :si, symbol: "kbit"},
    %{name: :kibit, mod: FileSize.Bit, exp: 1, system: :iec, symbol: "Kibit"},
    %{name: :mbit, mod: FileSize.Bit, exp: 2, system: :si, symbol: "Mbit"},
    %{name: :mibit, mod: FileSize.Bit, exp: 2, system: :iec, symbol: "Mibit"},
    %{name: :gbit, mod: FileSize.Bit, exp: 3, system: :si, symbol: "Gbit"},
    %{name: :gibit, mod: FileSize.Bit, exp: 3, system: :iec, symbol: "Gibit"},
    %{name: :tbit, mod: FileSize.Bit, exp: 4, system: :si, symbol: "Tbit"},
    %{name: :tibit, mod: FileSize.Bit, exp: 4, system: :iec, symbol: "Tibit"},
    %{name: :pbit, mod: FileSize.Bit, exp: 5, system: :si, symbol: "Pbit"},
    %{name: :pibit, mod: FileSize.Bit, exp: 5, system: :iec, symbol: "Pibit"},
    %{name: :ebit, mod: FileSize.Bit, exp: 6, system: :si, symbol: "Ebit"},
    %{name: :eibit, mod: FileSize.Bit, exp: 6, system: :iec, symbol: "Eibit"},
    %{name: :ebit, mod: FileSize.Bit, exp: 6, system: :si, symbol: "Ebit"},
    %{name: :eibit, mod: FileSize.Bit, exp: 6, system: :iec, symbol: "Eibit"},
    %{name: :zbit, mod: FileSize.Bit, exp: 7, system: :si, symbol: "Zbit"},
    %{name: :zibit, mod: FileSize.Bit, exp: 7, system: :iec, symbol: "Zibit"},
    %{name: :ybit, mod: FileSize.Bit, exp: 8, system: :si, symbol: "Ybit"},
    %{name: :yibit, mod: FileSize.Bit, exp: 8, system: :iec, symbol: "Yibit"},
    # Byte
    %{name: :b, mod: FileSize.Byte, exp: 0, system: nil, symbol: "B"},
    %{name: :kb, mod: FileSize.Byte, exp: 1, system: :si, symbol: "kB"},
    %{name: :kib, mod: FileSize.Byte, exp: 1, system: :iec, symbol: "KiB"},
    %{name: :mb, mod: FileSize.Byte, exp: 2, system: :si, symbol: "MB"},
    %{name: :mib, mod: FileSize.Byte, exp: 2, system: :iec, symbol: "MiB"},
    %{name: :gb, mod: FileSize.Byte, exp: 3, system: :si, symbol: "GB"},
    %{name: :gib, mod: FileSize.Byte, exp: 3, system: :iec, symbol: "GiB"},
    %{name: :tb, mod: FileSize.Byte, exp: 4, system: :si, symbol: "TB"},
    %{name: :tib, mod: FileSize.Byte, exp: 4, system: :iec, symbol: "TiB"},
    %{name: :pb, mod: FileSize.Byte, exp: 5, system: :si, symbol: "PB"},
    %{name: :pib, mod: FileSize.Byte, exp: 5, system: :iec, symbol: "PiB"},
    %{name: :eb, mod: FileSize.Byte, exp: 6, system: :si, symbol: "EB"},
    %{name: :eib, mod: FileSize.Byte, exp: 6, system: :iec, symbol: "EiB"},
    %{name: :zb, mod: FileSize.Byte, exp: 7, system: :si, symbol: "ZB"},
    %{name: :zib, mod: FileSize.Byte, exp: 7, system: :iec, symbol: "ZiB"},
    %{name: :yb, mod: FileSize.Byte, exp: 8, system: :si, symbol: "YB"},
    %{name: :yib, mod: FileSize.Byte, exp: 8, system: :iec, symbol: "YiB"}
  ]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"

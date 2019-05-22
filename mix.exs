defmodule FileSize.MixProject do
  use Mix.Project

  def project do
    [
      app: :file_size,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "File Size",
      source_url: "https://github.com/tlux/file_size",
      docs: [
        main: "FileSize",
        extras: ["README.md"],
        groups_for_modules: [
          Structs: [
            FileSize.Bit,
            FileSize.Byte
          ],
          Calculation: [
            FileSize.Calculable,
            FileSize.Comparable,
            FileSize.Convertible
          ],
          Conversion: [
            FileSize.Parser,
            FileSize.Sigil,
            FileSize.Formatter
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      {:math, "~> 0.3.0"},
      {:number, "~> 1.0.0"}
    ]
  end
end

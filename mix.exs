defmodule FileSize.MixProject do
  use Mix.Project

  def project do
    [
      app: :file_size,
      version: "3.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ],
      dialyzer: [plt_add_apps: [:ex_unit, :mix]],
      package: package(),

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
          Protocols: [
            FileSize.Calculable,
            FileSize.Comparable,
            FileSize.Convertible
          ],
          Reflection: [
            FileSize.Units,
            FileSize.Units.Info
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:decimal, ">= 1.0.0 and < 3.0.0", optional: true},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      {:excoveralls, "~> 0.11.0", only: :test},
      {:number, "~> 1.0"}
    ]
  end

  defp description do
    "A file size calculator, parser and formatter."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/tlux/file_size"
      }
    ]
  end
end

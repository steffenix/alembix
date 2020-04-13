defmodule Alembix.MixProject do
  use Mix.Project

  def project do
    [
      app: :alembix,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore.exs",
        list_unused_filters: true,
        plt_core_path: "priv/plts/",
        plt_add_apps: [:mix]
      ],
      package: package(),
      description: description()
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
      {:excoveralls, "~> 0.12", only: [:test]},
      {:ex_unit_sonarqube, "~> 0.1.2", only: [:dev, :test]},
      {:credo, "~> 1.0", runtime: false, only: [:dev]},
      {:git_hooks, "~> 0.3", runtime: false, only: [:dev]},
      {:dialyxir, "~> 1.0", runtime: false, only: [:dev]},
      {:sobelow, "~> 0.9", runtime: false, only: [:dev]},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false, only: [:dev, :test]}
    ]
  end

  defp description do
    """
      Supercharge your environment variable.
      On deployment Alembix can be used to ensure your enviroment variable are not missing.
      It can be useed to parse the enviroment variables.
    """
  end

  defp package do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "alembix",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/nash-io/alembix"}
    ]
  end
end

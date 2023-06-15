defmodule Joel.MixProject do
  use Mix.Project

  def project do
    [
      app: :joel,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Joel.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nostrum, github: "Kraigie/nostrum", override: true},
      {:nosedrum, "~> 0.5"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end

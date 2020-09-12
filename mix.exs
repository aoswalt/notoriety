defmodule Notoriety.MixProject do
  use Mix.Project

  def project() do
    [
      app: :notoriety,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  def application() do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript() do
    [
      main_module: Notoriety.CLI
    ]
  end

  defp deps() do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:yaml_front_matter, "~> 1.0.0"}
    ]
  end
end

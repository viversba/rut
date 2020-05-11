defmodule Rut.MixProject do
  use Mix.Project

  def project do
    [
      app: :rut,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Rut.Application, []}
    ]
  end

  defp description do
    """
    Library for extracting information from RUT file. Uses Mutool to achieve that.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", ""],
      maintainers: ["Nicolás Viveros"],
      links: %{"GitHub" => "https://dv-gittea-001.neiatec.com/nviverosb/rut"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:floki, "~> 0.26.0"},
      {:ex_doc, "~> 0.22.0", only: :dev},
      {:earmark, "~> 1.4.4", only: :dev}
    ]
  end
end

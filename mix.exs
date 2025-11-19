defmodule CookieConsent.MixProject do
  use Mix.Project

  @version "1.0.1"
  @source_url "https://github.com/unaffiliatedstudios/cookie_consent"

  def project do
    [
      app: :cookie_consent,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs()
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.20", only: :dev, runtime: false},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.24"},
      {:jason, "~> 1.4"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 0.18.16 or ~> 1.0"},
      {:sobelow, "~> 0.14", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    GDPR/CCPA compliant cookie consent banner for Phoenix LiveView applications.
    Handles Google Analytics and Meta Pixel consent with customizable preferences.
    """
  end

  defp package do
    [
      name: "cookie_consent",
      files: ~w(lib assets .formatter.exs mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end

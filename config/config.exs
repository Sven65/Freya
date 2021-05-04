use Mix.Config

dbPath = Path.join(File.cwd!(), "freya.db")

config :freya,
  ecto_repos: [Freya.Repo]

config :freya, Freya.Repo,
  database: dbPath
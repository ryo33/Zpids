use Mix.Config

# Configure your database
config :zpids_game, Zpids.Game.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: System.get_env("POOL_SIZE") |> String.to_integer(),
  ssl: true

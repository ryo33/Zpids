use Mix.Config

# Configure your database
config :zpids_game, Zpids.Game.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "zpids_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

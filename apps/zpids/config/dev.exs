use Mix.Config

# Configure your database
config :zpids, Zpids.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "zpids_dev",
  hostname: "localhost",
  pool_size: 10

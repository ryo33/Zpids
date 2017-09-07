use Mix.Config

# Configure your database
config :zpid, Zpid.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "zpid_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

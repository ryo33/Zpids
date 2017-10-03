# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :zpids_web,
  namespace: Zpids.Web,
  ecto_repos: [Zpids.Repo]

config :zpids_web, Zpids.Web,
  zpids_game_module: Zpids.Game,
  zpids_game_client_module: Zpids.Game.Client

# Configures the endpoint
config :zpids_web, Zpids.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Dik9T2RJFFGtjSFNM03O2Rwj6PoWuYbSdOAhAEsf/1wBJJl7DX6py/lEG03P8MOS",
  render_errors: [view: Zpids.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Zpids.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :zpids_web, :generators,
  context_app: :zpids

config :zpids_web, Zpids.Web.Guardian,
  issuer: "Zpids",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY") || "abcd"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

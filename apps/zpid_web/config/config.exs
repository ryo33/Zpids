# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :zpid_web,
  namespace: Zpid.Web,
  ecto_repos: [Zpid.Repo]

# Configures the endpoint
config :zpid_web, Zpid.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Dik9T2RJFFGtjSFNM03O2Rwj6PoWuYbSdOAhAEsf/1wBJJl7DX6py/lEG03P8MOS",
  render_errors: [view: Zpid.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Zpid.Web.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :zpid_web, :generators,
  context_app: :zpid

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

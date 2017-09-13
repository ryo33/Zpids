use Mix.Config

import_config "../apps/*/config/config.exs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "zpid.exs"
import_config "#{Mix.env}.exs"

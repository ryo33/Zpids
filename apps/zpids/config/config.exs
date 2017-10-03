use Mix.Config

config :zpids, ecto_repos: [Zpids.Repo]

import_config "#{Mix.env}.exs"

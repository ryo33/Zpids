use Mix.Config

config :zpid, ecto_repos: [Zpid.Repo]

import_config "#{Mix.env}.exs"

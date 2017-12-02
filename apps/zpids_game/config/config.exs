use Mix.Config

config :zpids_game, ecto_repos: [Zpids.Game.Repo]

import_config "#{Mix.env}.exs"


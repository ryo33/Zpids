use Mix.Config

config :zpid, ecto_repos: [Zpid.Repo]

config :zpid, Zpid.Application,
  children: [],
  display_width: 1600,
  display_height: 900

import_config "#{Mix.env}.exs"

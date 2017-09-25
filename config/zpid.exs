use Mix.Config

config :zpid, Zpid.Application,
  children: [
    {Zpid.Clock, []}]

config :zpid, Zpid,
  display_width: 1600,
  display_height: 900

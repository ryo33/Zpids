use Mix.Config

config :zpid, Zpid.Application,
  children: [
    {Zpid.Clock, []}
  ]

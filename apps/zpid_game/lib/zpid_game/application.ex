defmodule Zpid.Game.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Zpid.Clock,
    ]
    opts = [strategy: :one_for_one, name: Zpid.Game.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

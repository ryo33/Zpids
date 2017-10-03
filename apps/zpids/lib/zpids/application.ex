defmodule Zpids.Application do
  @moduledoc """
  The Zpids Application Service.

  The zpids system business domain lives in this application.

  Exposes API to clients such as the `Zpids.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Zpids.Repo, []),
      {Registry, keys: :duplicate, name: Zpids.EventDispatcher},
    ]
    Supervisor.start_link(children,
                          strategy: :one_for_one,
                          name: Zpids.Supervisor)
  end
end

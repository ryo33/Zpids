defmodule Zpid.Application do
  @moduledoc """
  The Zpid Application Service.

  The zpid system business domain lives in this application.

  Exposes API to clients such as the `Zpid.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Zpid.Repo, []),
      {Registry, keys: :duplicate, name: Zpid.EventDispatcher},
    ]
    Supervisor.start_link(children,
                          strategy: :one_for_one,
                          name: Zpid.Supervisor)
  end
end

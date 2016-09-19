defmodule SmppexWeb do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    SmppexWeb.MC.start

    dummy = fn(_) -> :ok end

    children = [
      worker(SmppexWeb.PduHistory, [&SmppexWeb.SmppConnectionsChannel.broadcast_update/1, dummy, [name: SmppexWeb.PduHistory]]),
      supervisor(SmppexWeb.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: SmppexWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    SmppexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

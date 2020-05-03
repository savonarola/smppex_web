defmodule SmppexWeb do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    SmppexWeb.MC.start

    children = [
      {Phoenix.PubSub, [name: SmppexWeb.PubSub, adapter: Phoenix.PubSub.PG2]},
      worker(SmppexWeb.PduHistory, [
        &SmppexWeb.SmppConnectionsChannel.broadcast_update/1,
        &SmppexWeb.SmppConnectionHistoryChannel.broadcast_update/1,
        [name: SmppexWeb.PduHistory]
      ]),
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

defmodule SmppexWeb.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    SmppexWeb.MC.start()

    children = [
      SmppexWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:smppex_web, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SmppexWeb.PubSub},
      {SmppexWeb.PduHistory, name: SmppexWeb.PduHistory},
      SmppexWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: SmppexWeb.Supervisor)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SmppexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

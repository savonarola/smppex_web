defmodule SmppexWeb.SmppConnectionsChannel do
  use SmppexWeb, :channel

  alias SmppexWeb.PduHistory

  @topic "smppConnections:list"

  def broadcast_update(system_ids) do
    SmppexWeb.Endpoint.broadcast!(@topic, "systemIdsUpdated", %{systemIds: system_ids})
  end

  @impl true
  def join(@topic, _message, socket) do
    {:ok, %{systemIds: PduHistory.system_ids()}, socket}
  end
end

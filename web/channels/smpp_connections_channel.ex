defmodule SmppexWeb.SmppConnectionsChannel do
  use Phoenix.Channel

  alias SmppexWeb.PduHistory

  @topic "smppConnections:list"

  def broadcast_update(system_ids) do
    SmppexWeb.Endpoint.broadcast!(@topic, "systemIdsUpdated", %{systemIds: system_ids})
  end

  def join(@topic, _message, socket) do
    {:ok, %{systemIds: PduHistory.system_ids}, socket}
  end

end

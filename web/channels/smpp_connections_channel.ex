defmodule SmppexWeb.SmppConnectionsChannel do
  use Phoenix.Channel

  alias SmppexWeb.PduHistory

  @topic "smpp_connections:list"

  def broadcast_update(system_ids) do
    SmppexWeb.Endpoint.broadcast!(@topic, "system_ids_updated", %{system_ids: system_ids})
  end

  def join(@topic, _message, socket) do
    {:ok, %{system_ids: PduHistory.system_ids}, socket}
  end

end

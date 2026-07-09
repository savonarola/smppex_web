defmodule SmppexWeb.UserSocket do
  use Phoenix.Socket

  channel "smppConnections:list", SmppexWeb.SmppConnectionsChannel
  channel "smppConnectionHistory:*", SmppexWeb.SmppConnectionHistoryChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end

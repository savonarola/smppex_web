defmodule SmppexWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "smppConnections:list", SmppexWeb.SmppConnectionsChannel
  channel "smppConnectionHistory:*", SmppexWeb.SmppConnectionHistoryChannel

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end

defmodule SmppexWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "smppConnections:list", SmppexWeb.SmppConnectionsChannel
  channel "smppConnectionHistory:*", SmppexWeb.SmppConnectionHistoryChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end

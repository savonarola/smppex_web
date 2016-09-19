defmodule SmppexWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "smpp_connections:list", SmppexWeb.SmppConnectionsChannel
  channel "smpp_connection_history:*", SmppexWeb.SmppConnectionHistoryChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end

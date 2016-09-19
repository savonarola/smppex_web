defmodule SmppexWeb.SmppConnectionHistoryChannel do
  use Phoenix.Channel

  alias SmppexWeb.PduHistory

  def join("smpp_connection_history:" <> system_id, _message, socket) do
    case PduHistory.history(system_id) do
      {:ok, _} -> {:ok, socket}
      {:error, :unknown_session} = err -> err
    end
  end

end


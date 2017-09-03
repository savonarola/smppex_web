defmodule SmppexWeb.SmppConnectionHistoryChannel do
  use Phoenix.Channel

  alias SMPPEX.Pdu
  alias SmppexWeb.PduHistory

  @channel "smppConnectionHistory:"

  def broadcast_update({system_id, pdu_info}) do
    topic = @channel <> system_id
    SmppexWeb.Endpoint.broadcast!(topic, "newPdu", %{pduInfo: to_maps(pdu_info)})
  end

  def join(@channel <> system_id, _message, socket) do
    case PduHistory.history(system_id) do
      {:ok, history} -> {:ok, %{history: Enum.map(history, &to_maps/1)}, socket}
      {:error, :unknown_session} = err -> err
    end
  end

  def to_maps({id, time, {direction, pdu}}) do
    %{
      id: id,
      time: time,
      direction: to_string(direction),
      pdu: %{
        command_name: Pdu.command_name(pdu),
        command_id: Pdu.command_id(pdu),
        command_status: Pdu.command_status(pdu),
        sequence_number: Pdu.sequence_number(pdu),
        mandatory_fields: pdu |> Pdu.mandatory_fields |> stringify_keys,
        optional_fields: pdu |> Pdu.optional_fields |> stringify_keys
      }
    }
  end

  defp stringify_keys(map) do
    Enum.into(map, %{}, fn {k, v} -> {to_string(k), v} end)
  end

end

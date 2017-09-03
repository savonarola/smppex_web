defmodule SmppexWeb.SmppConnectionHistoryChannelTest do

  use ExUnit.Case

  alias SMPPEX.Pdu
  alias SmppexWeb.SmppConnectionHistoryChannel, as: Channel

  test "to_maps" do
    pdu = Pdu.new({4, 0, 0})
    |> Pdu.set_optional_field(:message_payload, "hello")
    |> Pdu.set_optional_field(3333, "hello")

    record = {123, :erlang.system_time(:milli_seconds), {:in, pdu}}
    assert is_binary(record |> Channel.to_maps |> Poison.encode!)
  end

end

defmodule SmppexWeb.MCTest do

  use ExUnit.Case

  alias SMPPEX.ESME.Sync, as: ESME
  alias SMPPEX.Pdu
  alias SMPPEX.Pdu.Factory
  alias SmppexWeb.PduHistory

  def wait do
    :timer.sleep(20)
  end

  def connect do
    wait
    {:ok, esme} = ESME.start_link("localhost", Application.get_env(:smppex_web, SmppexWeb.MC)[:port])
    esme
  end

  test "bind" do
    esme = connect
    {:ok, bind_resp} = ESME.request(esme, Factory.bind_transmitter("system_id", "pass"))

    assert Pdu.success_resp?(bind_resp)
    assert PduHistory.system_ids == ["system_id"]
  end

  test "unbind" do
    esme = connect
    {:ok, bind_resp} = ESME.request(esme, Factory.bind_transmitter("system_id1", "pass"))

    assert Pdu.success_resp?(bind_resp)

    ESME.stop(esme)

    wait

    assert PduHistory.system_ids == []
  end

  test "bind with same system_id" do
    esme1 = connect
    {:ok, bind_resp1} = ESME.request(esme1, Factory.bind_transmitter("system_id2", "pass"))

    assert Pdu.success_resp?(bind_resp1)

    esme2 = connect
    {:ok, bind_resp2} = ESME.request(esme2, Factory.bind_transmitter("system_id2", "pass"))

    refute Pdu.success_resp?(bind_resp2)
  end

  test "submit_sm" do
    esme = connect
    {:ok, _} = ESME.request(esme, Factory.bind_transmitter("system_id3", "pass"))

    {:ok, submit_sm_resp} = ESME.request(esme, Factory.submit_sm({"from", 1, 1}, {"to", 1, 1}, "hello"))

    assert Pdu.success_resp?(submit_sm_resp)
  end

  test "system_id history" do
    esme = connect
    {:ok, _} = ESME.request(esme, Factory.bind_transmitter("system_id4", "pass"))

    submit_sm = Factory.submit_sm({"from", 1, 1}, {"to", 1, 1}, "hello")
    {:ok, _} = ESME.request(esme, submit_sm)

    assert {:ok, [
      {_, {:out, pdu4}},
      {_, {:in, pdu3}},
      {_, {:out, pdu2}},
      {_, {:in, pdu1}}
    ]} = PduHistory.history("system_id4")

    assert Pdu.command_name(pdu4) == :submit_sm_resp
    assert Pdu.command_name(pdu3) == :submit_sm
    assert Pdu.command_name(pdu2) == :bind_transmitter_resp
    assert Pdu.command_name(pdu1) == :bind_transmitter
  end

end


defmodule SmppexWeb.PduHistoryTest do
  use ExUnit.Case

  alias SMPPEX.Pdu
  alias SmppexWeb.PduHistory

  defp pdu(command_id) do
    Pdu.new({command_id, 0, 0})
  end

  test "register_session" do
    {:ok, server} = PduHistory.start_link()

    assert :ok == PduHistory.register_session(server, "system_id1")
  end

  test "register_session: already registered" do
    {:ok, server} = PduHistory.start_link()

    assert :ok == PduHistory.register_session(server, "system_id1")

    assert {:error, :session_alredy_registered} ==
             PduHistory.register_session(server, "system_id1")
  end

  test "register_session: system_id already registered" do
    {:ok, server} = PduHistory.start_link()

    spawn_link(fn ->
      PduHistory.register_session(server, "system_id")
      :timer.sleep(1000)
    end)

    :timer.sleep(10)

    assert {:error, :system_id_alredy_registered} ==
             PduHistory.register_session(server, "system_id")
  end

  test "register_pdu" do
    {:ok, server} = PduHistory.start_link()

    assert :ok == PduHistory.register_session(server, "system_id")
    assert :ok == PduHistory.register_pdu(server, {:in, pdu(1)})
  end

  test "register_pdu: unknown_session" do
    {:ok, server} = PduHistory.start_link()

    assert {:error, :unknown_session} == PduHistory.register_pdu(server, {:in, pdu(1)})
  end

  test "history" do
    {:ok, server} = PduHistory.start_link()

    assert :ok == PduHistory.register_session(server, "system_id")
    assert :ok == PduHistory.register_pdu(server, {:in, pdu(1)})
    assert :ok == PduHistory.register_pdu(server, {:out, pdu(2)})

    assert {:ok,
            [
              {2, _, {:out, pdu2}},
              {1, _, {:in, pdu1}}
            ]} = PduHistory.history(server, "system_id")

    assert Pdu.command_id(pdu1) == 1
    assert Pdu.command_id(pdu2) == 2
  end

  test "history: unknown session" do
    {:ok, server} = PduHistory.start_link()

    assert {:error, :unknown_session} == PduHistory.history(server, "system_id")
  end
end

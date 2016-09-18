defmodule SmppexWeb.PduHistoryTest do

  use ExUnit.Case

  alias SmppexWeb.PduHistory

  def dummy(_) do
    :ok
  end

  test "register_session" do
    {:ok, server} = PduHistory.start_link(&dummy/1, &dummy/1)

    assert :ok == PduHistory.register_session(server, "system_id1")
  end

  test "register_session: already registered" do
    {:ok, server} = PduHistory.start_link(&dummy/1, &dummy/1)

    assert :ok == PduHistory.register_session(server, "system_id1")
    assert {:error, :session_alredy_registered} == PduHistory.register_session(server, "system_id2")
  end

  test "register_session: system_id already registered" do
    {:ok, server} = PduHistory.start_link(&dummy/1, &dummy/1)

    spawn_link fn() ->
      PduHistory.register_session(server, "system_id")
      :timer.sleep(1000)
    end

    :timer.sleep(10)

    assert {:error, :system_id_alredy_registered} == PduHistory.register_session(server, "system_id")
  end

  test "register_pdu" do
    {:ok, server} = PduHistory.start_link(&dummy/1, &dummy/1)

    assert :ok == PduHistory.register_session(server, "system_id")
    assert :ok == PduHistory.register_pdu(server, :pdu)
  end

  test "register_pdu: unknown_session" do
    {:ok, server} = PduHistory.start_link(&dummy/1, &dummy/1)

    assert {:error, :unknown_session} == PduHistory.register_pdu(server, :pdu)
  end

  test "history" do
    {:ok, server} = PduHistory.start_link(&dummy/1, &dummy/1)

    assert :ok == PduHistory.register_session(server, "system_id")
    assert :ok == PduHistory.register_pdu(server, :pdu1)
    assert :ok == PduHistory.register_pdu(server, :pdu2)

    assert {:ok, [{2, :pdu2}, {1, :pdu1}]} == PduHistory.history(server, "system_id")
  end

  test "history: unknown session" do
    {:ok, server} = PduHistory.start_link(&dummy/1, &dummy/1)

    assert {:error, :unknown_session} == PduHistory.history(server, "system_id")
  end

  test "on_sessions_changed callback" do
    {:ok, pid} = Agent.start_link(fn() -> [] end)

    on_sessions_changed = fn(sessions) ->
      Agent.update(pid, fn(changes) ->
        [sessions | changes]
      end)
    end

    {:ok, server} = PduHistory.start_link(on_sessions_changed, &dummy/1)

    spawn_link fn() ->
      PduHistory.register_session(server, "system_id")
    end

    :timer.sleep(10)

    assert [[], ["system_id"]] == Agent.get(pid, fn(changes) -> changes end)
  end

  test "on_new_pdu callback" do
    {:ok, pid} = Agent.start_link(fn() -> [] end)

    on_new_pdu = fn({_system_id, _pdu} = pdu_info) ->
      Agent.update(pid, fn(pdus) ->
        [pdu_info | pdus]
      end)
    end

    {:ok, server} = PduHistory.start_link(&dummy/1, on_new_pdu)

    assert :ok == PduHistory.register_session(server, "system_id")
    assert :ok == PduHistory.register_pdu(server, :pdu1)
    assert :ok == PduHistory.register_pdu(server, :pdu2)

    assert [{"system_id", {2, :pdu2}}, {"system_id", {1, :pdu1}}] == Agent.get(pid, fn(changes) -> changes end)
  end

end


defmodule SmppexWeb.PduHistory do

  use GenServer

  alias SmppexWeb.PduHistory

  defstruct [
    on_sessions_changed: nil,
    on_new_pdu: nil,
    sid_by_pid: %{},
    history_by_sid: %{},
    last_id: 0
  ]

  @history_limit 1000

  def start_link(on_sessions_changed, on_new_pdu, opts \\ []) do
    GenServer.start_link(__MODULE__, [on_sessions_changed, on_new_pdu], opts)
  end

  def init([on_sessions_changed, on_new_pdu]) do
    {:ok, %PduHistory{
      on_sessions_changed: on_sessions_changed,
      on_new_pdu: on_new_pdu
    }}
  end

  @type server :: atom | pid

  @spec register_session(server, system_id :: String.t) :: :ok | {:error, :session_alredy_registered} | {:error, :system_id_alredy_registered}

  def register_session(server, system_id) do
    GenServer.call(server, {:register_session, self(), system_id})
  end

  def register_session(system_id), do: PduHistory.register_session(PduHistory, system_id)

  @spec register_pdu(server, term) :: :ok | {:error, :unknown_session}

  def register_pdu(server, pdu_info) do
    GenServer.call(server, {:register_pdu, self(), pdu_info})
  end

  def register_pdu(pdu_info), do: register_pdu(PduHistory, pdu_info)

  @spec history(server, system_id :: String.t) :: {:ok, [term]} | {:error, :unknown_session}

  def history(server, system_id) do
    GenServer.call(server, {:history, system_id})
  end

  def history(system_id), do: history(PduHistory, system_id)

  @spec system_ids(server) :: [String.t]

  def system_ids(server) do
    GenServer.call(server, :system_ids)
  end

  def system_ids, do: system_ids(PduHistory)

  def handle_call({:register_session, pid, system_id}, _from, st) do
    cond do
      Map.has_key?(st.sid_by_pid, pid) ->
        {:reply, {:error, :session_alredy_registered}, st}
      Map.has_key?(st.history_by_sid, system_id) ->
        {:reply, {:error, :system_id_alredy_registered}, st}
      true ->
        {:reply, :ok, do_register_session(pid, system_id, st)}
    end
  end

  def handle_call({:register_pdu, session_pid, pdu_info}, _from, st) do
    if Map.has_key?(st.sid_by_pid, session_pid) do
      {:reply, :ok, do_register_pdu(session_pid, pdu_info, st)}
    else
      {:reply, {:error, :unknown_session}, st}
    end
  end

  def handle_call({:history, system_id}, _from, st) do
    if Map.has_key?(st.history_by_sid, system_id) do
      {:reply, {:ok, st.history_by_sid[system_id]}, st}
    else
      {:reply, {:error, :unknown_session}, st}
    end
  end

  def handle_call(:system_ids, _from, st) do
    {:reply, do_get_system_ids(st), st}
  end

  defp do_register_session(pid, system_id, st) do
    new_st = %PduHistory{ st |
      sid_by_pid: Map.put(st.sid_by_pid, pid, system_id),
      history_by_sid: Map.put(st.history_by_sid, system_id, [])
    }
    Process.monitor(pid)
    notify_system_ids(new_st)
    new_st
  end

  defp notify_system_ids(st) do
    st.on_sessions_changed.(do_get_system_ids(st))
  end

  defp do_get_system_ids(st) do
    Map.keys(st.history_by_sid)
  end

  def handle_info({:DOWN, _ref, :process, session_pid, _reason}, st) do
    if Map.has_key?(st.sid_by_pid, session_pid) do
      {:noreply, do_unregister_session(session_pid, st)}
    else
      {:noreply, st}
    end
  end

  defp do_unregister_session(pid, st) do
    system_id = Map.get(st.sid_by_pid, pid)
    new_st = %PduHistory{ st |
      sid_by_pid: Map.delete(st.sid_by_pid, pid),
      history_by_sid: Map.delete(st.history_by_sid, system_id)
    }
    notify_system_ids(new_st)
    new_st
  end

  defp do_register_pdu(pid, pdu_info, st) do
    system_id = Map.get(st.sid_by_pid, pid)
    id = st.last_id + 1
    time = :erlang.system_time(:milli_seconds)
    history_item = {id, time, pdu_info}
    new_history = append_history(st.history_by_sid[system_id], history_item)

    new_st = %PduHistory{ st |
      history_by_sid: Map.put(st.history_by_sid, system_id, new_history),
      last_id: id
    }
    st.on_new_pdu.({system_id, history_item})
    new_st
  end

  defp append_history(history, pdu_info) do
    [pdu_info | Enum.take(history, @history_limit - 1)]
  end

end

defmodule SmppexWeb.MC do

  use SMPPEX.Session

  alias SMPPEX.Pdu
  alias SMPPEX.Pdu.Factory
  alias SMPPEX.Pdu.Errors
  alias SMPPEX.Session
  alias SmppexWeb.PduHistory

  @system_id "smppex_web"

  def start do
    config = Application.get_env(:smppex_web, __MODULE__)
    port = config[:port]
    max_connections = config[:max_connections]
    {:ok, _ref} = SMPPEX.MC.start({__MODULE__, []}, [transport_opts: [port: port, max_connections: max_connections]])
  end

  def init(_socket, _transport, []) do
    {:ok, %{
      bound: false,
      last_msg_id: 1,
    }}
  end

  def handle_resp(pdu, _original_pdu, st) do
    do_save_pdu({:in, pdu})
    {:ok, st}
  end

  def handle_pdu(pdu, st) do
    case Pdu.command_name(pdu) do
      :bind_transmitter -> do_handle_bind(pdu, st)
      :bind_receiver -> do_handle_bind(pdu, st)
      :bind_transceiver -> do_handle_bind(pdu, st)
      :submit_sm -> do_handle_submit_sm(pdu, st)
      :enquire_link -> do_handle_enquire_link(pdu, st)
      :unbind -> do_handle_unbind(pdu, st)
      _ -> {:ok, st}
    end
  end

  def handle_send_pdu_result(pdu, _send_pdu_result, st) do
    do_save_pdu({:out, pdu})
    st
  end

  def handle_cast(:stop, st) do
    {:stop, :normal, st}
  end

  # Private

  defp do_handle_bind(pdu, st) do
    if st[:bound] do
      {:ok, [bind_resp(pdu, :ROK)], st}
    else
      system_id = Pdu.field(pdu, :system_id)
      case PduHistory.register_session(system_id) do
        :ok ->
          do_save_pdu({:in, pdu})
          {:ok, [bind_resp(pdu, :ROK)], %{st | bound: true}}
        {:error, _} ->
          {:ok, [bind_resp(pdu, :RALYBND)], st}
      end
    end
  end

  defp bind_resp(pdu, command_status) do
    Factory.bind_resp(
      bind_resp_command_id(pdu),
      Errors.code_by_name(command_status),
      @system_id
    ) |> Pdu.as_reply_to(pdu)
  end

  defp bind_resp_command_id(pdu), do: 0x80000000 + Pdu.command_id(pdu)

  defp do_handle_enquire_link(pdu, st) do
    do_save_pdu({:in, pdu})
    resp = Factory.enquire_link_resp |> Pdu.as_reply_to(pdu)
    {:ok, [resp], st}
  end

  defp do_handle_submit_sm(pdu, st) do
    if st[:bound] do
      do_save_pdu({:in, pdu})
      code = Errors.code_by_name(:ROK)
      msg_id = st[:last_msg_id] + 1
      resp = Factory.submit_sm_resp(code, to_string(msg_id)) |> Pdu.as_reply_to(pdu)
      {:ok, [resp], %{st | last_msg_id: msg_id}}
    else
      code = Errors.code_by_name(:RINVBNDSTS)
      resp = Factory.submit_sm_resp(code) |> Pdu.as_reply_to(pdu)
      {:ok, [resp], st}
    end
  end

  defp do_save_pdu(pdu_info) do
    PduHistory.register_pdu(pdu_info)
  end

  defp do_handle_unbind(pdu, st) do
    if st[:bound] do
      do_save_pdu({:in, pdu})
      resp = Factory.unbind_resp |> Pdu.as_reply_to(pdu)
      stop()
      {:ok, [resp], st}
    else
      code = Errors.code_by_name(:RINVBNDSTS)
      resp = Factory.unbind_resp(code) |> Pdu.as_reply_to(pdu)
      {:ok, [resp], st}
    end
  end

  defp stop do
    Session.cast(self(), :stop)
  end
end

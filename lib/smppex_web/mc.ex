defmodule SmppexWeb.MC do

  use SMPPEX.MC
  alias SMPPEX.MC

  alias SMPPEX.Pdu
  alias SMPPEX.Pdu.Factory
  alias SMPPEX.Pdu.Errors
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

  def handle_pdu(pdu, st) do
    new_st = case Pdu.command_name(pdu) do
      :bind_transmitter -> do_handle_bind(pdu, st)
      :bind_receiver -> do_handle_bind(pdu, st)
      :bind_transceiver -> do_handle_bind(pdu, st)
      :submit_sm -> do_handle_submit_sm(pdu, st)
      :enqure_link -> do_handle_enquire_link(pdu, st)
      _ -> st
    end
    do_save_pdu({:in, pdu})
    new_st
  end

  def handle_send_pdu_result(pdu, _send_pdu_result, st) do
    do_save_pdu({:out, pdu})
    st
  end

  def do_handle_bind(pdu, st) do
    if st[:bound] do
      reply_bind(pdu, :ROK)
      st
    else
      system_id = Pdu.field(pdu, :system_id)
      case PduHistory.register_session(system_id) do
        :ok ->
          reply_bind(pdu, :ROK)
          %{ st | bound: true }
        {:error, _} ->
          reply_bind(pdu, :RALYBND)
          st
      end
    end
  end

  defp reply_bind(pdu, status), do: MC.reply(self, pdu, bind_resp(pdu, status))

  defp bind_resp(pdu, command_status) do
    Factory.bind_resp(
      bind_resp_command_id(pdu),
      Errors.code_by_name(command_status),
      @system_id
    )
  end

  defp bind_resp_command_id(pdu), do: 0x80000000 + Pdu.command_id(pdu)

  def do_handle_enquire_link(pdu, st) do
    MC.reply(self, pdu, Factory.enquire_link_resp)
    st
  end

  def do_handle_submit_sm(pdu, st) do
    if st[:bound] do
      code = Errors.code_by_name(:ROK)
      msg_id = st[:last_msg_id] + 1
      resp = Factory.submit_sm_resp(code, to_string(msg_id))
      MC.reply(self, pdu, resp)
      %{st | last_msg_id: msg_id}
    else
      code = Errors.code_by_name(:RINVBNDSTS)
      resp = Factory.submit_sm_resp(code)
      MC.reply(self, pdu, resp)
      st
    end
  end

  defp do_save_pdu(pdu_info) do
    PduHistory.register_pdu(pdu_info)
  end

end

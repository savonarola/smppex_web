defmodule SmppexWeb.MC do

  use SMPPEX.MC

  def start do
    config = Application.get_env(:smppex_web, __MODULE__)
    port = config[:port]
    max_connections = config[:max_connections]
    {:ok, _ref} = SMPPEX.MC.start({__MODULE__, []}, [transport_opts: [port: port, max_connections: max_connections]])
  end

end

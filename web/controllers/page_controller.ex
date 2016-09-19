defmodule SmppexWeb.PageController do
  use SmppexWeb.Web, :controller

  alias SmppexWeb.PduHistory

  def index(conn, _params) do
    conn
    |> assign(:system_ids, PduHistory.system_ids)
    |> render("index.html")
  end
end

defmodule SmppexWeb.PageController do
  use SmppexWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

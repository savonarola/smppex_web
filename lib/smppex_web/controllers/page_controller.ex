defmodule SmppexWeb.PageController do
  use SmppexWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end

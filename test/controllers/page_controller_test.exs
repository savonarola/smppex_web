defmodule SmppexWeb.PageControllerTest do
  use SmppexWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "app-container"
  end
end

defmodule SmppexWeb.ErrorHTMLTest do
  use SmppexWeb.ConnCase, async: true

  test "renders 404.html" do
    assert SmppexWeb.ErrorHTML.render("404.html", []) == "Page not found"
  end

  test "render 500.html" do
    assert SmppexWeb.ErrorHTML.render("500.html", []) == "Internal server error"
  end

  test "render any other" do
    assert SmppexWeb.ErrorHTML.render("505.html", []) ==
             Phoenix.Controller.status_message_from_template("505.html")
  end
end

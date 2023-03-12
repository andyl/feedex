defmodule FeedexWeb.ErrorJSONTest do
  use FeedexWeb.ConnCase, async: true

  test "renders 404" do
    assert FeedexWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert FeedexWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end

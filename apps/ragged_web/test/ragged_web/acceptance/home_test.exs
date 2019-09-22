defmodule Acceptance.HomeTest do
  use ExUnit.Case, async: false
  use RaggedData.DataCase
  use Hound.Helpers
  use RaggedWeb.HoundCase

  describe "basic page loading" do
    test "load single page" do
      navigate_to("http://localhost:4001")
      assert page_title() == "Ragged"
    end

    test "load multi pages" do
      navigate_to("http://localhost:4001")
      assert page_title() == "Ragged"
      navigate_to("http://localhost:4001")
      assert page_title() == "Ragged"
    end
  end

  describe "auth redirection" do
    test "redirects to login page" do
      navigate_to("http://localhost:4001/news")
      assert current_path() == "/"
    end
  end

  describe "login" do
    test "page exists" do
      navigate_to("http://localhost:4001/sessions/new")
      assert page_source() =~ "Login"
    end

    test "login works" do
      assert count(User) == 0
      load_test_data()
      assert count(User) == 1
      navigate_to("http://localhost:4001/sessions/new")
      find_element(:id, "session_email") |> fill_field("test")
      find_element(:id, "session_pwd")   |> fill_field("test")
      find_element(:id, "submit_btn")    |> click()
      assert current_path() == "/"
    end

    test "login with function" do
      load_test_data()
      do_login()
      take_screenshot("/tmp/test.png")
      assert current_path() == "/news"
    end

  end
end

defmodule RaggedWeb.HoundCase do
  use ExUnit.CaseTemplate
  use Hound.Helpers

  using do
    quote do
      import RaggedWeb.HoundCase
    end
  end

  setup _tags do
    Hound.start_session()
    :ok
  end

  def do_login(_args \\ []) do
    navigate_to("http://localhost:4001/sessions/new")
    find_element(:id, "session_email") |> fill_field("test")
    find_element(:id, "session_pwd") |> fill_field("test")
    find_element(:id, "submit_btn") |> click()
    navigate_to("http://localhost:4001/news")
    :ok
  end
end

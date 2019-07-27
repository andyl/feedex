defmodule RaggedClientTest do
  use ExUnit.Case
  doctest RaggedClient

  test "#probe/0" do
    assert RaggedClient.probe("url") == :ok 
  end

  test "#get/0" do
    assert RaggedClient.get("url") == :ok 
  end
end

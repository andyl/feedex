defmodule RaggedClientTest do
  use ExUnit.Case
  doctest RaggedClient

  test "#probe/0" do
    assert RaggedClient.probe() == :ok 
  end

  test "#get/0" do
    assert RaggedClient.get() == :ok 
  end
end

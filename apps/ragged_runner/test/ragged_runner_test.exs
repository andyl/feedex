defmodule RaggedRunnerTest do
  use ExUnit.Case
  doctest RaggedRunner

  test "says hello" do
    assert RaggedRunner.hello() == :world
  end
end

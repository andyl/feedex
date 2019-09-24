defmodule FeedexWeb.Cache.PushStateTest do
  use ExUnit.Case

  alias FeedexWeb.Cache.{UiState, PushState}

  setup do
    PushState.cleanup()
    :ok
  end

  describe "#save" do
    test "returns a hash-key" do
      payload1 = %UiState{usr_id: 1}
      payload2 = %UiState{usr_id: 2}
      assert hash_key1 = PushState.save(payload1)
      assert hash_key2 = PushState.save(payload2)
      assert hash_key1 != hash_key2
    end
  end

  describe "#lookup" do
    test "returns a payload" do
      payload1 = %UiState{usr_id: 1}
      assert hash_key1 = PushState.save(payload1)
      assert payload_x = PushState.lookup(hash_key1)
      assert payload_x = payload1
    end

    test "generates a fresh UiState if key not found" do
      assert payload = PushState.lookup("asdf")
      assert payload.usr_id == 1
    end
  end
end

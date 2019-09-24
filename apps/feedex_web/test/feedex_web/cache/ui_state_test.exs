defmodule FeedexWeb.Cache.UiStateTest do
  use ExUnit.Case

  alias FeedexWeb.Cache.UiState

  setup do
    UiState.cleanup()
    :ok
  end

  describe "#struct" do
    test "creates a struct" do
      assert %UiState{}
    end
  end

  describe "#save" do
    test "returns a UiState" do
      assert {id, ui_state} = UiState.save(%{usr_id: 1})
      assert ui_state.mode     == "view"
      assert ui_state.usr_id   == 1
    end

    test "updates a UiState" do
      assert {id, ui_state} = UiState.save(%{usr_id: 1, mode: "edit"})
      assert ui_state.mode       == "edit"
      assert ui_state.usr_id     == 1
    end
  end

  describe "#lookup" do
    test "returns a payload" do
      assert {id, ui_state} = UiState.save(%{usr_id: 1})
      assert ui_state.usr_id == 1
      assert result = UiState.lookup(1)
      assert result.usr_id == 1
    end
  end
end

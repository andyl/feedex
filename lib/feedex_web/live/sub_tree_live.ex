defmodule FeedexWeb.SubTreeLive do
  @moduledoc """
  This LiveView is for importing a JSON data structure with subscription settings.
  """

  use FeedexWeb, :live_view

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, session, socket) do
    user = FeedexWeb.SessionUtil.user_from_session(session)

    opts = %{
      result: "OK",
      current_user: user
    }

    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>IMPORT</h1>
      Paste JSON Text here
      <form phx-submit="save">
        <textarea
          type="textarea"
          name="json"
          class="border-2 border-gray-900 form-textarea h-50"
          rows="10"
        ></textarea>
        <button type="submit" class="block">Submit</button>
      </form>

      <div class="mt-10"></div>
    </div>
    """
  end

  # ----- view helpers -----

  # ----- data helpers -----

  # ----- message handlers -----

  # ----- event handlers -----

  @impl true
  def handle_event("save", session, socket) do
    user = socket.assigns.current_user
    json = session["json"]

    result =
      try do
        Feedex.Api.SubTree.import_tree_json(user.id, json)
        "SUCCESS"
      rescue
        _ -> "ERROR BAD DATA"
      end

    {:noreply, assign(socket, :result, result)}
  end
end

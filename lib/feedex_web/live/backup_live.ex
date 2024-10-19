defmodule FeedexWeb.BackupLive do
  @moduledoc """
  This LiveView is for importing a JSON data structure with subscription settings.
  """

  use FeedexWeb, :live_view

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, session, socket) do
    user = FeedexWeb.SessionUtil.user_from_session(session)
    path = Feedex.Backup.backup_path()

    opts = %{
      file_path: path,
      file_exists: File.exists?(path),
      message: "",
      current_user: user
    }

    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h3 class="pt-10 pb-5"><b>SUBSCRIPTION BACKUP AND RESTORE</b></h3>

      <div class="pb-5">
        BACKUP FILE: <%= @file_path %>
      </div>

      <div>
        <.alink phx-click="export" href="#">EXPORT</.alink>
        <span :if={@file_exists}>
          |
          <.alink phx-click="view" href="#">VIEW</.alink>
          |
          <.alink phx-click="import" href="#">IMPORT</.alink>
        </span>
      </div>
      <div class="pt-10"><%= @message %></div>
    </div>
    """
  end

  # ----- view helpers -----

  # ----- data helpers -----

  # ----- message handlers -----

  # ----- event handlers -----

  @impl true
  def handle_event("export", _session, socket) do
    subs = socket.assigns.current_user.id |> Feedex.Api.SubTree.list()
    json = JSON.encode!(subs)
    File.write(socket.assigns.file_path, json)

    results = %{
      message: "EXPORTED",
      file_exists: true
    }

    {:noreply, assign(socket, results)}
  end

  @impl true
  def handle_event("view", _session, socket) do
    json = socket.assigns.file_path |> File.read!()
    IO.inspect(socket.assigns.file_path)
    IO.inspect(json)
    {:noreply, assign(socket, :message, json)}
  end

  @impl true
  def handle_event("import", _session, socket) do
    user = socket.assigns.current_user
    json = socket.assigns.file_path |> File.read!()

    result =
      try do
        Feedex.Api.SubTree.import_tree_json(user.id, json)
        "SUCCESS"
      rescue
        _ -> "ERROR BAD DATA"
      end

    {:noreply, assign(socket, :message, result)}
  end
end

defmodule FeedexWeb.NewsLive do
  @moduledoc """
  Renders the news page.
  """

  use FeedexWeb, :live_view

  alias FeedexWeb.Cache.UiState
  alias FeedexWeb.Cache.UiParams

  require Logger

  # ----- lifecycle callbacks -----

  @impl true
  def mount(params, session, socket) do
    user = FeedexWeb.SessionUtil.user_from_session(session)
    treemap = Feedex.Api.SubTree.cleantree(user.id)

    FeedexWeb.Endpoint.subscribe("new_posts")

    opts = %{
      email: live_flash(socket.assigns.flash, :email),
      current_user: user,
      uistate: UiState.lookup(user.id) |> UiParams.merge_params(params),
      treemap: treemap
    }

    {:ok, assign(socket, opts)}
  end

  @impl true
  def handle_params(params, uri, socket) do
    user = socket.assigns.current_user

    uistate = %{
      mode: params["mode"] || "view",
      usr_id: user.id,
      fld_id: params["fld_id"] |> numify(),
      reg_id: params["reg_id"] |> numify(),
      pst_id: params["pst_id"] |> numify(),
      timestamp: DateTime.utc_now()
    }

    opts = %{
      uistate: uistate,
      counts: gen_counts(user.id),
      path: URI.parse(uri).path
    }

    {:noreply, assign(socket, opts)}
  end

  defp numify(nil), do: nil
  defp numify(val), do: String.to_integer(val)

  # ----- HEEX -----

  @impl true
  def render(assigns) do
    ~H"""
    <div class="w-full">
      <div class="flex">
        <div class="pl-3 bg-slate-300 flex-none w-52">
          <div>
            <%= live_render(@socket, FeedexWeb.ClockLive, id: "clock") %>
          </div>
          <div>
            <.live_component module={FeedexWeb.TreeComponent}
              id='tre' uistate={@uistate} treemap={@treemap} counts={@counts} />
          </div>
          <div>
            <.live_component module={FeedexWeb.BtnComponent} id='btn' uistate={@uistate} />
          </div>
        </div>
        <div class="flex-auto">
          <div class="bg-slate-300">
            <.live_component module={FeedexWeb.HdrComponent}
              id='hdr' uistate={@uistate} treemap={@treemap} counts={@counts} />
          </div>
          <div class="bg-white">
            <.live_component module={FeedexWeb.BodyComponent} id='bdy' uistate={@uistate}
              counts={@counts} />
          </div>
        </div>
      </div>
    </div>
    """
  end

  # ----- data helpers -----

  def gen_counts(user_id) do
    %{
      all: Feedex.Ctx.News.unread_count_for(user_id),
      fld: Feedex.Ctx.News.unread_aggregate_count_for(user_id, type: "fld"),
      reg: Feedex.Ctx.News.unread_aggregate_count_for(user_id, type: "reg")
    }
  end

  # ----- message handlers -----

  @impl true
  def handle_info({"set_uistate", %{uistate: new_state}}, socket) do
    args = new_state |> UiParams.clean() |> UiParams.strip()
    {:noreply, push_patch(socket, to: ~p"/news?#{args}")}
  end

  @impl true
  def handle_info("mod_tree", socket) do
    user = socket.assigns.current_user

    treemap = Feedex.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      fld_id: nil,
      reg_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      counts: gen_counts(user.id),
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  # ----- FOLDERS -----

  @impl true
  def handle_info({"new_folder", %{fld_id: fld_id}}, socket) do
    user = socket.assigns.current_user

    treemap = Feedex.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      fld_id: fld_id,
      reg_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info({"update_folder", %{fld_id: fld_id}}, socket) do
    user = socket.assigns.current_user
    treemap = Feedex.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      reg_id: nil,
      fld_id: fld_id
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info("delete_folder", socket) do
    user = socket.assigns.current_user

    treemap = Feedex.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      fld_id: nil,
      reg_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  # ----- FEEDS -----

  @impl true
  def handle_info({"new_feed", %{reg_id: reg_id}}, socket) do
    user = socket.assigns.current_user

    treemap = Feedex.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      reg_id: reg_id,
      fld_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info({"delete_feed", %{fld_id: fld_id}}, socket) do
    user = socket.assigns.current_user

    treemap = Feedex.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      reg_id: nil,
      fld_id: fld_id
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      counts: gen_counts(user.id),
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info("save_feed", socket) do
    user = socket.assigns.current_user

    treemap = Feedex.Api.SubTree.cleantree(user.id)

    new_opts = %{
      mode: "view",
      pst_id: nil,
      fld_id: nil
    }

    new_state =
      socket.assigns.uistate
      |> Map.merge(new_opts)

    opts = %{
      treemap: treemap,
      uistate: new_state
    }

    {:noreply, assign(socket, opts)}
  end

  @impl true
  def handle_info("SYNC_FEED", socket) do
    user = socket.assigns.current_user

    Logger.info("RECEIVE SYNC_FEED")

    treemap = Feedex.Api.SubTree.cleantree(user.id)

    opts = %{
      treemap: treemap,
      counts: gen_counts(user.id)
    }

    {:noreply, assign(socket, opts)}
  end

  # ----- POSTS -----

  @impl true
  def handle_info("mark_all_read", socket) do
    opts = %{counts: gen_counts(socket.assigns.current_user.id)}
    {:noreply, assign(socket, opts)}
  end

  # ----- DEFAULT FOR DEBUGGING -----

  @impl true
  def handle_info(default, socket) do
    IO.puts("<<<<< DEFAULT HANDLE_INFO START >>>>>")
    IO.inspect(default, label: "DEFAULT PARAMS")
    IO.inspect(socket, label: "DEFAULT SOCKET")
    IO.puts("<<<<< DEFAULT HANDLE_INFO STOP >>>>>")
    {:noreply, socket}
  end
end

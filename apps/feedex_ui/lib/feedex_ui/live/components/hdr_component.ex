defmodule FeedexUi.HdrComponent do
  @moduledoc """
  Renders the hdr component.

  Call using:

      <%= live_component(@socket, FeedexUi.HdrComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  alias Phoenix.HTML
  alias FeedexData.Ctx.{Account, News}

  # def mount(session, socket) do
  #   FeedexWeb.Endpoint.subscribe("set_uistate")
  #   FeedexWeb.Endpoint.subscribe("tree_mod")
  #   FeedexWeb.Endpoint.subscribe("read_one")
  #   count = if Application.fetch_env(:feedex_web, :env) == {:ok, :test} do
  #     0
  #   else
  #     News.unread_count(session.uistate)
  #   end
  #   {:ok, assign(socket, %{unread: count, uistate: session.uistate})}
  # end

  def update(assigns, socket) do
    IO.inspect assigns, label: "UPDATE"
    {:ok, assign(socket, uistate: assigns.uistate, unread: 22)}
  end

  def render(assigns) do
    ~L"""
    <div class='bg-gray-300 desktop-only'>
    <%= if @uistate.mode == "view" do %>
    <div class='row' style="background-color: lightgray; padding-top: 4px; padding-bottom: 4px; margin-bottom: 10px;">
    <div class='col-md-6'>
      <%= title(@uistate, @unread) %>
    </div>
    <div class='text-right col-md-6'>
      <%= HTML.raw btns(@uistate) %>
    </div>
    </div>
    <% end %>
    </div>
    """
  end

  # ----- view helpers -----
  
  defp title(state, unread) do
    case {state.reg_id, state.fld_id} do
      {nil    , nil} -> all_name(unread)
      {reg_id, nil}  -> register_name(reg_id, unread)
      {nil, fld_id}  -> folder_name(fld_id, unread)
    end |> HTML.raw()
  end

  def mark_all_read(state) do
    case {state.fld_id, state.reg_id} do
      {nil   , nil} -> Account.mark_all_for(state.usr_id)
      {fld_id, nil} -> Account.mark_all_for(state.usr_id, fld_id: fld_id)
      {nil, reg_id} -> Account.mark_all_for(state.usr_id, reg_id: reg_id)
    end
  end

  def sync_all(state) do
    case {state.fld_id, state.reg_id} do
      {nil   , nil} -> FeedexJob.sync_for(state.usr_id)
      {fld_id, nil} -> FeedexJob.sync_for(state.usr_id, fld_id: fld_id)
      {nil, reg_id} -> FeedexJob.sync_for(state.usr_id, reg_id: reg_id)
    end
  end

  defp checklink(unread) do
    style = "style='vertical-align: top; margin-top: 4px; margin-right: 5px; margin-left: 5px;'"
    case unread do
      0 -> ""
      _ -> 
      """
      <small><span class="badge badge-light" #{style}>#{unread}</span></small>
      <span style="margin-right: 10px">
       <a href='#'>
      <i class='fa fa-check' phx-click='mark-read'></i>
      </a>  
      </span>
      """
    end 
  end

  defp all_name(count) do
    "ALL " <> checklink(count)
  end

  defp folder_name(folder_id, unread) do
    FeedexData.Ctx.Account.folder_get(folder_id).name <> checklink(unread)
  end

  defp register_name(register_id, unread) do
    reg = FeedexData.Ctx.Account.register_get(register_id)
    fld = FeedexData.Ctx.Account.folder_get(reg.folder_id)
    flnk = "<a href='#' phx-click='folder-clk' phx-value-fldid='#{fld.id}'>#{fld.name}</a> "
    flnk <> "> " <> FeedexData.Ctx.Account.register_get(register_id).name <> checklink(unread)
  end

  defp btns(state) do
    show_pencil = state.reg_id != nil || state.fld_id != nil
    pencil = 
      if show_pencil do
        """
        <a href='#' phx-click='click-edit'>
        <i class='fa fa-pencil-alt'></i>
        </a>
        """
      else
        ""
      end

    """
    <a href='#'>
    <i class='fa fa-redo' phx-click='feed-sync' style='margin-right: 10px;'></i>
    </a>
    #{pencil}
    """
  end
  
end

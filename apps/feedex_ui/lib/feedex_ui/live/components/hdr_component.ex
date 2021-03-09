defmodule FeedexUi.HdrComponent do
  @moduledoc """
  Renders the hdr component.

  Call using:

      <%= live_component(@socket, FeedexUi.HdrComponent, uistate: @uistate) %>

  """

  use Phoenix.LiveComponent

  alias Phoenix.HTML
  alias FeedexData.Ctx.Account
  alias FeedexData.Util.Treemap
  import FeedexUi.CountHelpers

  def render(assigns) do
    ~L"""
    <div class='px-2 bg-gray-400 desktop-only'>
    <%= if @uistate.mode == "view" do %>
      <div class=''>
        <div class=''>
          <%= title(@uistate, @counts, @treemap) %>
        </div>
        <!--
        <div class='text-right'>
          <%= HTML.raw btns(@uistate) %>
        </div>
        --> 
      </div>
    <% end %>
    </div>
    """
  end

  # ----- view helpers -----
  
  defp title(state, counts, treemap) do
    case {state.reg_id, state.fld_id} do
      {nil    , nil} -> all_name(counts)
      {nil, fld_id}  -> folder_name(fld_id, counts, treemap)
      {reg_id, nil}  -> register_name(reg_id, counts, treemap)
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

  # defp checklink(unread) do
  #   style = "style='vertical-align: top; margin-top: 4px; margin-right: 5px; margin-left: 5px;'"
  #   case unread do
  #     0 -> ""
  #     _ -> 
  #     """
  #     <small><span class="badge badge-light" #{style}>#{unread}</span></small>
  #     <span style="margin-right: 10px">
  #      <a href='#'>
  #     <i class='fa fa-check' phx-click='mark-read'></i>
  #     </a>  
  #     </span>
  #     """
  #   end 
  # end

  defp all_name(counts) do
    # "ALL " <> checklink(counts)
    "ALL " <> unread(counts.all)
  end

  defp folder_name(folder_id, counts, treemap) do
    fname = Treemap.folder_name(treemap, folder_id)
    count = counts.fld[folder_id] || 0
    # label = if unread > 0, do: "(#{unread})", else: ""
    label = if count > 0, do: unread(count), else: ""
    "#{fname} #{label}"
  end

  defp register_name(register_id, counts, treemap) do
    count = counts.reg[register_id] || 0
    reg_name = Treemap.register_name(treemap, register_id)
    fld_id   = Treemap.register_parent_id(treemap, register_id)
    fld_name = Treemap.register_parent_name(treemap, register_id)
    fld_base = "href='#' class='bluelink' phx-click='folder-clk' phx-value-fldid='#{fld_id}'"
    fld_link = "<a #{fld_base}>#{fld_name}</a> "
    label = if count > 0, do: unread(count), else: ""
    "#{fld_link} > #{reg_name} #{label}"
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

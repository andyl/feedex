defmodule FeedexWeb.BodyEditFeedComponent do
  @moduledoc """
  Renders the body edit feed component.

  Call using:

      <%= live_component(FeedexUi.BodyEditFeedComponent, uistate: @uistate) %>

  """

  alias Feedex.Ctx.News.Post
  alias Feedex.Ctx.News.Feed

  alias Feedex.Ctx.Account

  alias Feedex.Repo

  import Ecto.Query
  import Phoenix.HTML

  import FeedexWeb.CoreComponents

  use Phoenix.LiveComponent

  require Logger

  # ----- lifecycle callbacks -----

  @impl true
  def update(session, socket) do
    reg_id = session.uistate.reg_id
    usr_id = session.uistate.usr_id
    register = Repo.get(Account.Register, reg_id)
    regform = Repo.get(Account.RegForm, reg_id)

    opts =
      if register do
        feed_count =
          from(reg in Account.Register,
            select: count(reg.id),
            where: reg.feed_id == ^register.feed_id
          )
          |> Repo.one()

        post_count =
          from(pst in Post, select: count(pst.id), where: pst.feed_id == ^register.feed_id)
          |> Repo.one()

        folders =
          from(fld in Account.Folder,
            select: {fld.name, fld.id},
            where: fld.user_id == ^usr_id,
            order_by: fld.name
          )
          |> Repo.all()

        %{
          register: regform,
          changeset: Account.RegForm.changeset(regform, %{}),
          form: to_form(Account.RegForm.changeset(regform, %{})),
          feed_count: feed_count,
          feed: Repo.get(Feed, register.feed_id),
          folder: Repo.get(Account.Folder, register.folder_id),
          folders: folders,
          post_count: post_count,
          uistate: session.uistate
        }
      else
        %{
          register: nil,
          feed_count: 0,
          feed: nil,
          folder: nil,
          folders: nil,
          post_count: 0,
          changeset: %Account.RegForm{},
          uistate: session.uistate
        }
      end

    {:ok, assign(socket, opts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>EDIT FEED</h1>
      <%= if @register do %>
        <.simple_form
          :let={f}
          for={@changeset}
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >
          <.input field={{f, :name}} label="Feed Name" />
          <.input
            type="select"
            field={{f, :folder_id}}
            value={@folder.id}
            options={@folders}
            label="Folder"
          />
          <:actions>
            <%= if @changeset.valid? do %>
              <.button>Save</.button>
            <% else %>
              <.button class="line-through">Save</.button>
            <% end %>
          </:actions>
        </.simple_form>
      <% end %>

      <%= if @register do %>
        <table class="table">
          <tr>
            <td>Reg Name:</td>
            <td>TBD</td>
          </tr>
          <tr>
            <td>Reg Folder:</td>
            <td>TBD</td>
          </tr>
          <tr>
            <td>FeedUrl:</td>
            <td><%= feed_link(@feed) %></td>
          </tr>
          <tr>
            <td>Usr/Registry ID:</td>
            <td><%= @register.id %></td>
          </tr>
          <tr>
            <td>Attached Registries:</td>
            <td><%= @feed_count %></td>
          </tr>
          <tr>
            <td>Post Count:</td>
            <td><%= @post_count %></td>
          </tr>
          <tr>
            <td>Sync Count:</td>
            <td><%= @feed.sync_count %></td>
          </tr>
        </table>
        <p style="margin-bottom: 60px;"></p>
        <button type="button" phx-click="delete" phx-target={@myself} class="btn btn-danger">
          Delete Feed
        </button>
      <% end %>
    </div>
    """
  end

  # ----- view helpers -----

  def feed_link(feed) do
    """
    <a href="#{feed.url}" target="_blank">
    #{feed.url}
    </a>
    """
    |> raw()
  end

  # ----- data helpers -----

  # ----- event handlers -----

  @impl true
  def handle_event("delete", _payload, socket) do
    register = Repo.get(Account.Register, socket.assigns.uistate.reg_id)

    fld_id = register.folder_id

    feed_count =
      from(r in Account.Register, select: count(r.id), where: r.feed_id == ^register.feed_id)
      |> Repo.one()

    try do
      if feed_count == 1 do
        Repo.get(Account.Feed, register.feed_id) |> Repo.delete()
      end
    rescue
      _ -> Logger.info("Warning: delete feed error")
    end

    try do
      Repo.delete(register)
    rescue
      _ -> Logger.info("Warning: delete register error")
    end

    send(self(), {"delete_feed", %{fld_id: fld_id}})

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", payload, socket) do
    data = %{
      folder_id: payload["reg_form"]["folder_id"] |> String.to_integer(),
      name: payload["reg_form"]["name"]
    }

    Account.Register
    |> Repo.get(socket.assigns.uistate.reg_id)
    |> IO.inspect(label: "DINGLE")
    |> Ecto.Changeset.change(data)
    |> Repo.update()

    send(self(), "save_feed")
    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", payload, socket) do
    IO.puts("--------- VALIDATE")
    IO.inspect(payload, label: "PAYLOAD")

    cset =
      socket.assigns.register
      |> Account.RegForm.changeset(payload)
      |> IO.inspect(label: "CSET")

    {:noreply, assign(socket, changeset: cset, form: to_form(cset))}
  end

  @impl true
  def handle_event(target, payload, socket) do
    IO.inspect(target, label: "TARGET")
    IO.inspect(payload, label: "PAYLOAD")
    {:noreply, socket}
  end
end

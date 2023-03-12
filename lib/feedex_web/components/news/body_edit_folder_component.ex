defmodule FeedexWeb.BodyEditFolderComponent do
  @moduledoc """
  Renders the body view component.

  Call using:

      <%= live_component(@socket, FeedexUi.BodyComponent, uistate: @uistate) %>

  """

  alias Feedex.Ctx.Account
  alias Feedex.Api

  import FeedexWeb.CoreComponents

  use Phoenix.LiveComponent

  # ----- lifecycle callbacks -----

  @impl true
  def update(session, socket) do
    if socket.assigns[:folder] do
      {:ok, socket}
    else
      opts = %{
        changeset: Account.Folder.new_changeset(),
        uistate: session.uistate,
        reg_count: Api.Folder.register_count(session.uistate.fld_id),
        folder:
          Api.Folder.by_id(session.uistate.fld_id)
          |> Api.Folder.map_subset([:name, :stopwords])
      }

      {:ok, assign(socket, opts)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="font-bold">Edit Folder</div>
      <div>
        <.simple_form
          :let={f}
          for={@changeset}
          phx-target={@myself}
          phx-change="validate"
          phx-submit="save"
        >
          <.input field={{f, :name}} value={@folder.name} label="Folder Name" />
          <.input
            field={{f, :stopwords}}
            value={@folder.stopwords}
            label="Stopwords (separate with |)"
          />
          <p>
            Folder ID: <%= @uistate.fld_id %><br /> Num Feeds: <%= @reg_count %><br />
          </p>
          <:actions>
            <%= if @changeset.valid? do %>
              <.button>Save</.button>
            <% else %>
              <.button class="line-through">Save</.button>
            <% end %>
          </:actions>
        </.simple_form>
        <.button :if={@reg_count == 0} class="mt-10" phx-click="delete" phx-target={@myself}>
          Delete Folder
        </.button>
      </div>
    </div>
    """
  end

  # ----- event handlers -----

  @impl true
  def handle_event("validate", payload, socket) do
    cset =
      payload["folder"]
      |> Map.merge(%{"id" => socket.assigns.uistate.fld_id})
      |> Api.Folder.folder_validation_changeset()

    {:noreply, assign(socket, :changeset, cset)}
  end

  @impl true
  def handle_event("save", payload, socket) do
    fldid = socket.assigns.uistate.fld_id
    opts =
      payload["folder"]
      |> Map.merge(%{"stopwords" => clean_stopwords(payload["stopwords"])})
      |> Map.merge(%{"id" => socket.assigns.uistate.fld_id})

    Api.Folder.by_id(fldid)
    |> Api.Folder.update_folder(opts)

    send(self(), {"update_folder", %{fld_id: fldid}})

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    Api.Folder.by_id(socket.assigns.uistate.fld_id)
    |> Api.Folder.delete_folder()

    send(self(), "delete_folder")

    {:noreply, socket}
  end

  # -----

  defp clean_stopwords(input) do
    case input do
      nil ->
        nil

      "" ->
        nil

      words ->
        words
        |> String.split("|")
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.downcase/1)
        |> Enum.sort()
        |> Enum.uniq()
        |> Enum.join("|")
    end
  end
end

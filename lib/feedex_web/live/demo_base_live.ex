defmodule FeedexWeb.DemoBaseLive do
  use FeedexWeb, :live_view

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, _session, socket) do
    opts = %{}

    {:ok, assign(socket, opts)}
  end

  @impl true
  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, :current_path, path_for(url))}
  end

  # ----- HEEX -----

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <h1 class="pt-2 pb-1 text-xl font-bold">
          Demo Base
        </h1>
        <.demonav current_path={@current_path} />
      </div>
      <div class="mt-2 mb-2 p-2 border-solid border-purple-600 border">
        Border demo<br />
        <.alink href="http://google.com">GOOGLE</.alink>
      </div>
      <div class="">
        done
      </div>
    </div>
    """
  end
end

defmodule FeedexWeb.DemoSaladLive do
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
          Demo Salad
        </h1>
        <.demonav current_path={@current_path} />
      </div>
      <div class="orangebox">
        2024 Jul 09 Tue: Salad doesn't work
      </div>
      <div class="">
        done
      </div>
    </div>
    """
  end
end

defmodule FeedexWeb.DemoSaladLive do
  use FeedexWeb, :live_view

  import SaladUI.Alert

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
        <.alert>
          <.icon name="hero-command-line" class="h-4 w-4" />
          <.alert_title>Heads up!</.alert_title>
          <.alert_description>
            You can add components to your app using the cli
          </.alert_description>
        </.alert>
      </div>
      <div class="">
        done
      </div>
    </div>
    """
  end

  # ----- DING -----

  # def pong do
  #   SaladUI.Alert.
  # end
end

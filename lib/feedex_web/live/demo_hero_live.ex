defmodule FeedexWeb.DemoHeroLive do
  use FeedexWeb, :live_view

  alias Heroicons, as: Icon

  import Heroicons

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
          Demo Hero
        </h1>
        <.demonav current_path={@current_path} />
      </div>
      <div class="orangebox">
        } <Heroicons.cake class="inline-block w-8 h-8" /> base<br />
        } <Heroicons.cake solid class="inline-block w-8 h-8" /> solid<br />
        } <Heroicons.cake mini class="inline-block w-8 h-8" /> mini<br />
        } <Heroicons.cake micro class="inline-block w-8 h-8" /> micro<br />
      </div>
      <div class="orangebox">
        } <Icon.cake class="inline-block w-8 h-8" /> base<br />
        } <Icon.cake solid class="inline-block w-8 h-8" /> solid<br />
        } <Icon.cake mini class="inline-block w-8 h-8" /> mini<br />
        } <Icon.cake micro class="inline-block w-8 h-8" /> micro<br />
      </div>
      <div class="orangebox">
        } <Icon.cake class="icon" /> base<br />
        } <Icon.cake solid class="icon" /> solid<br />
        } <Icon.cake mini class="icon" /> mini<br />
        } <Icon.cake micro class="icon" /> micro<br />
      </div>
      <div class="orangebox">
        } <.cake class="icon" /> base<br />
        } <.cake solid class="icon" /> solid<br />
        } <.cake mini class="icon" /> mini<br />
        } <.cake micro class="icon" /> micro<br />
      </div>
      <div class="">
        done
      </div>
    </div>
    """
  end
end

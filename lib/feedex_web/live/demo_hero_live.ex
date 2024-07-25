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
        } <Icon.cake class="icon-4" /> base<br />
        } <Icon.cake solid class="icon-4" /> solid<br />
        } <Icon.cake mini class="icon-4" /> mini<br />
        } <Icon.cake micro class="icon-4" /> micro<br />
      </div>
      <div class="orangebox">
        } <.cake class="icon-8" /> base<br />
        } <.cake solid class="icon-8" /> solid<br />
        } <.cake mini class="icon-8" /> mini<br />
        } <.cake micro class="icon-8" /> micro<br />
      </div>
      <div class="orangebox">
        } <.command_line class="icon-6" /> base<br />
        } <.command_line solid class="icon-6" /> solid<br />
        } <.command_line mini class="icon-6" /> mini<br />
        } <.command_line micro class="icon-6" /> micro<br />
      </div>
      <div class="">
        done
      </div>
    </div>
    """
  end
end

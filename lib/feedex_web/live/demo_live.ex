defmodule FeedexWeb.DemoLive do

  use FeedexWeb, :live_view

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, _session, socket) do

    # IO.inspect(params, label: "DEMO_PARAMS")
    # IO.inspect(session, label: "DEMO_SESSION")
    # IO.inspect(socket, label: "DEMO_SOCKET")

    opts = %{
    }

    {:ok, assign(socket, opts)}
  end

  # ----- HEEX -----

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <h1 class="pt-2 pb-1 text-xl font-bold">
          HEEX / Tailwind Demo Page
        </h1>
      </div>
      <div class="mt-2 mb-2 p-2 border-solid border-orange-500 border">
        Border demo<br/>
        <.alink href="http://google.com">GOOGLE</.alink>
      </div>
      DONE
    </div>
    """
  end
end

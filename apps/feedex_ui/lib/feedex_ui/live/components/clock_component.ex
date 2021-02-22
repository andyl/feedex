defmodule FeedexUi.ClockComponent do
  @moduledoc """
  Renders a live clock that updates at a periodic interval.

  The clock update frequency (`interval`) and the output format (`strftime`)
  are configurable options.

  To call from the parent template:
  
      <%= live_component(@socket, FeedexUi.ClockComponent, id: 1, interval: 10_000 %>
      <%= live_component(@socket, FeedexUi.ClockComponent, id: 2, strftime: "%H:%M" %>

  To make this work, the parent LiveView needs a handle_info function:

      @impl true
      def handle_info({:tick, assigns}, socket) do
        send_update FeedexUi.ClockComponent, assigns
        {:noreply, socket}
      end

  The parent `handle_info` is required because there is no `handle_info
  `callback for LiveComponent.  

  Ben Wilson (@benwilson512) on Elixir Forum says that in the future, there may
  be a `send_update` feature to allow external processes to ping the component
  directly.

  https://elixirforum.com/t/livecomponent-updating-itself-at-regular-intervals/37047/6

  Also the code in the `update` callback is more complex than desired.

  Ideally the timer would start once in the `mount` callback.  This was not
  possible because the timer interval should be configurable in the assigns,
  and the assigns are not available in the `mount` params. (AFAIK)

  Maybe there is a simpler approach for starting the timer...
  """

  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
    <%= @date %>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    opts = update_assigns(assigns) 
    unless assigns[:timer], do: start_timer(opts)
    {:ok, assign(socket, opts)}
  end

  defp update_assigns(assigns) do
    strftime = assigns[:strftime] || "%H:%M:%S"
    [
      id: assigns[:id],
      timer: "started",
      interval: assigns[:interval] || 1000,
      strftime: strftime,
      date: local_date(strftime)
    ]
  end

  defp local_date(format) do
    NaiveDateTime.local_now()
    |> Calendar.strftime(format)
  end

  defp start_timer(opts) do
    :timer.send_interval(opts[:interval], self(), {:tick, opts})
  end
end

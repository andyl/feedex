defmodule FeedexUi.ClockLive do
  @moduledoc """
  Renders a live clock that updates at a periodic interval.

  The clock update frequency (`interval`) and the output format (`strftime`)
  are configurable session options.

  To call from the parent template:

      <%= live_render(@socket, FeedexUi.ClockLive, id: 1, session: %{"interval" => 10_000}) %>
      <%= live_render(@socket, FeedexUi.ClockLive, id: 2, session: %{"strftime" => "%H:%M"}) %>

  """

  use Phoenix.LiveView

  @impl true
  def mount(_params, session, socket) do
    start_timer(session["interval"] || 1000)
    strftime = session["strftime"] || "%H:%M:%S"
    state = [strftime: strftime, date: local_date(strftime)]
    {:ok, assign(socket, state)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= @date %>
    """
  end

  @impl true
  def handle_info(:clock_tick, socket) do
    newdate = socket.assigns.strftime |> local_date()
    {:noreply, update(socket, :date, fn _ -> newdate end)}
  end

  defp start_timer(interval) do
    :timer.send_interval(interval, self(), :clock_tick)
  end

  defp local_date(format) do
    NaiveDateTime.local_now()
    |> Calendar.strftime(format)
  end
end

defmodule FeedexWeb.AppComponents do
  @moduledoc """
  Provides app UI components.
  """
  use Phoenix.Component

  @doc """
  Renders a styled link.
  """
  attr :href, :string, doc: "the link href"
  attr :class, :string, doc: "custom classes", default: ""
  attr :rest, :global, doc: "custom HTML attributes", default: %{}
  slot :inner_block, required: true

  def alink(assigns) do
    ~H"""
    <.link
      class={"underline decoration-2 decoration-blue-400 hover:decoration-blue-800 #{@class}"}
      href={@href}
      {@rest}
    ><%= render_slot(@inner_block) %></.link>
    """
  end

  @doc """
  Conditionally renders a styled link.
  """
  attr :href, :string, doc: "the link href"
  attr :current_path, :string, doc: "current path", default: ""
  attr :class, :string, doc: "custom classes", default: ""
  attr :rest, :global, doc: "custom HTML attributes", default: %{}
  slot :inner_block, required: true

  def clink(assigns) do
    if assigns.current_path == assigns.href do
    ~H"""
      <b>
        <%= render_slot(@inner_block) %>
      </b>
    """
    else
    ~H"""
    <.link
      class={"underline decoration-2 decoration-blue-400 hover:decoration-blue-800 #{@class}"}
      href={@href}
      {@rest}
    ><%= render_slot(@inner_block) %></.link>
    """
    end
  end

  @doc """
  Renders a navbar for demo pages
  """
  attr :current_path, :string, doc: "current path", default: ""

  def demonav(assigns) do
    ~H"""
    <div>
      <.clink current_path={@current_path} href="/demo_base">Base</.clink>
      |
      <.clink current_path={@current_path} href="/demo_daisy">Daisy</.clink>
      |
      <.clink current_path={@current_path} href="/demo_salad">Salad</.clink>
      |
      <.clink current_path={@current_path} href="/demo_tailwind">Tailwind</.clink>
    </div>
    """
  end
end

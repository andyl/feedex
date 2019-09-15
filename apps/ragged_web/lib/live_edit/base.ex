defmodule LiveEdit.Base do
  import Phoenix.LiveView

  import Phoenix.HTML

  # ----- view helpers -----
  def live_edit(assigns, label, opts) do
    Keyword.has_key?(opts, :id) || raise("Needs ID option")
    id = opts[:id]
    focus = assigns[:focus]

    if id == focus do
      form_text(label, opts) |> raw()
    else
      raw("<span class='editable-click' phx-click='focus' phx-value='#{id}'>#{label}</span>")
    end
  end

  defp form_text(label, opts) do
    """
    <form phx-change="#{opts[:on_change]}" phx-submit="#{opts[:on_submit]}">
      <input type="text" value="#{label}">
      <button type='submit'><i class='fa fa-check-square'></i></button>
      <button phx-click='cancel'><i class='fa fa-window-close'></i></button>
    </form>
    """
  end

  defmacro __using__(_opts) do
    quote do
      import LiveEdit.Base

      # ----- event handlers -----
      def handle_event("focus", payload, socket) do
        {:noreply, assign(socket, focus: payload)}
      end

      def handle_event("cancel", payload, socket) do
        {:noreply, assign(socket, focus: nil)}
      end
    end
  end
end

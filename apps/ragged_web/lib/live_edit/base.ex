defmodule LiveEdit.Base do

  import Phoenix.LiveView

  import Phoenix.HTML

  # ----- view helpers -----
  
  def live_edit(label, opts) do
    Keyword.has_key?(opts, :id) || raise("Needs ID option")
    Keyword.has_key?(opts, :focus) || raise("Needs Focus option")
    id = opts[:id]
    focus = opts[:focus]
    if id == focus do
      raw "<input type=text value='#{label}'/>"
    else
      raw "<span class='editable-click' phx-click='focus' phx-value='#{id}'>#{label}</span>"
    end
  end

  # ----- event handlers -----

  def handle_event("focus", payload, socket) do
    IO.inspect "---------------------------------------"
    IO.inspect payload
    IO.inspect "---------------------------------------"
    {:noreply, assign(socket, focus: payload)}
  end
end

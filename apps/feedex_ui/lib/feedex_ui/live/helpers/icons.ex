defmodule FeedexUi.Icons do

  import Phoenix.HTML

  def check_circle(:raw), do: check_circle() |> raw()
  def check_circle(klas, :raw), do: check_circle(klas) |> raw()
  def check_circle(klas \\ "") do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
    </svg>
    """
  end

  def plus_circle(:raw), do: plus_circle() |> raw()
  def plus_circle(klas, :raw), do: plus_circle(klas) |> raw()
  def plus_circle(klas \\ "") do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z" clip-rule="evenodd" />
    </svg>
    """
  end

  def refresh(:raw), do: refresh() |> raw()
  def refresh(klas, :raw), do: refresh(klas) |> raw()
  def refresh(klas \\ "") do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
    <path fill-rule="evenodd" d="M4 2a1 1 0 011 1v2.101a7.002 7.002 0 0111.601 2.566 1 1 0 11-1.885.666A5.002 5.002 0 005.999 7H9a1 1 0 010 2H4a1 1 0 01-1-1V3a1 1 0 011-1zm.008 9.057a1 1 0 011.276.61A5.002 5.002 0 0014.001 13H11a1 1 0 110-2h5a1 1 0 011 1v5a1 1 0 11-2 0v-2.101a7.002 7.002 0 01-11.601-2.566 1 1 0 01.61-1.276z" clip-rule="evenodd" />
    </svg>
    """
  end

  def pencil_alt(:raw), do: pencil_alt() |> raw()
  def pencil_alt(klas, :raw), do: pencil_alt(klas) |> raw()
  def pencil_alt(klas \\ "") do
    """
    <svg class="#{klas}" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
    <path d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z" />
    <path fill-rule="evenodd" d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" clip-rule="evenodd" />
    </svg>
    """
  end

end

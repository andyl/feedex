defmodule FeedexWeb.DemoDaisyLive do
  use FeedexWeb, :live_view

  # ----- lifecycle callbacks -----

  @impl true
  def mount(_params, _session, socket) do
    opts = %{}

    {:ok, assign(socket, opts)}
  end

  # ----- HEEX -----

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div>
        <h1 class="pt-2 pb-1 text-xl font-bold">
          Demo Daisy
        </h1>
        <.demonav />
      </div>
      <div class="mt-2 mb-2 p-2 border-solid border-orange-500 border">
        <div class="badge badge-outline">default</div>
        <div class="badge badge-primary badge-outline">primary</div>
        <div class="badge badge-secondary badge-outline">secondary</div>
        <div class="badge badge-accent badge-outline">accent</div>
      </div>
      <div class="mt-2 mb-2 p-2 border-solid border-orange-500 border">
        <button class="btn">Button</button>
        <button class="btn btn-neutral">Neutral</button>
        <button class="btn btn-primary">Primary</button>
        <button class="btn btn-secondary">Secondary</button>
        <button class="btn btn-accent">Accent</button>
        <button class="btn btn-ghost">Ghost</button>
        <button class="btn btn-link">Link</button>
      </div>
      <div class="mt-2 mb-2 p-2 border-solid border-orange-500 border">
        <div class="chat chat-start">
          <div class="chat-bubble">
            It's over Anakin, <br /> I have the high ground.
          </div>
        </div>
        <div class="chat chat-end">
          <div class="chat-bubble">You underestimate my power!</div>
        </div>
      </div>

      <div class="mt-2 mb-2 p-2 border-solid border-orange-500 border">
        <kbd class="kbd kbd-lg">Shift</kbd>
        <kbd class="kbd kbd-md">Shift</kbd>
        <kbd class="kbd kbd-sm">Shift</kbd>
        <kbd class="kbd kbd-xs">Shift</kbd>
      </div>

      <div class="mt-2 mb-2 p-2 border-solid border-orange-500 border">
        <div class="overflow-x-auto">
          <table class="table">
            <!-- head -->
            <thead>
              <tr>
                <th></th>
                <th>Name</th>
                <th>Job</th>
                <th>Favorite Color</th>
              </tr>
            </thead>
            <tbody>
              <!-- row 1 -->
              <tr>
                <th>1</th>
                <td>Cy Ganderton</td>
                <td>Quality Control Specialist</td>
                <td>Blue</td>
              </tr>
              <!-- row 2 -->
              <tr>
                <th>2</th>
                <td>Hart Hagerty</td>
                <td>Desktop Support Technician</td>
                <td>Purple</td>
              </tr>
              <!-- row 3 -->
              <tr>
                <th>3</th>
                <td>Brice Swyre</td>
                <td>Tax Accountant</td>
                <td>Red</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="">
        done
      </div>
    </div>
    """
  end
end

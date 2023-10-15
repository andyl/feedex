# defmodule Feedex.PromEx do
#   @moduledoc """
#   PromEx
#   """
#
#   use PromEx, otp_app: :feedex
#
#   alias PromEx.Plugins
#
#   @impl true
#   def plugins do
#     [
#       Plugins.Application,
#       Plugins.Beam,
#       {Plugins.Phoenix, router: FeedexWeb.Router, endpoint: FeedexWeb.Endpoint},
#       Plugins.Ecto,
#       Plugins.PhoenixLiveView,
#     ]
#   end
#
#   @impl true
#   def dashboard_assigns do
#     [
#       datasource_id: "ZZZ",
#       default_selected_interval: "30s"
#     ]
#   end
#
#   @impl true
#   def dashboards do
#     [
#       {:prom_ex, "application.json"},
#       {:prom_ex, "beam.json"},
#       {:prom_ex, "phoenix.json"},
#       {:prom_ex, "ecto.json"},
#       {:prom_ex, "phoenix_live_view.json"},
#     ]
#   end
# end

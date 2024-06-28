defmodule FeedexWeb.Metrics.InfluxHandler do

  def app_count do
    :telemetry.execute([:feedex, :app, :count], Feedex.Metrics.count())
  end

end

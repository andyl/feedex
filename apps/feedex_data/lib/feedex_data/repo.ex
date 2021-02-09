defmodule FeedexData.Repo do
  use Ecto.Repo,
    otp_app: :feedex_data,
    adapter: Ecto.Adapters.Postgres
end

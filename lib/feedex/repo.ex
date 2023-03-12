defmodule Feedex.Repo do
  use Ecto.Repo,
    otp_app: :feedex,
    adapter: Ecto.Adapters.Postgres
end

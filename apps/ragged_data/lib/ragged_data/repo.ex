defmodule RaggedData.Repo do
  use Ecto.Repo,
    otp_app: :ragged_data,
    adapter: Ecto.Adapters.Postgres
end

defmodule Harvest.Repo do
  use Ecto.Repo,
    otp_app: :harvest,
    adapter: Ecto.Adapters.Postgres
end

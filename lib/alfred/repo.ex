defmodule Alfred.Repo do
  use Ecto.Repo,
    otp_app: :alfred,
    adapter: Ecto.Adapters.Postgres
end

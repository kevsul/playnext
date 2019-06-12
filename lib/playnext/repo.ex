defmodule Playnext.Repo do
  use Ecto.Repo,
    otp_app: :playnext,
    adapter: Ecto.Adapters.Postgres
end

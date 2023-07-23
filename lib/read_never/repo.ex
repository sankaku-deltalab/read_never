defmodule ReadNever.Repo do
  use Ecto.Repo,
    otp_app: :read_never,
    adapter: Ecto.Adapters.SQLite3
end

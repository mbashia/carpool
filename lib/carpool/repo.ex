defmodule Carpool.Repo do
  use Ecto.Repo,
    otp_app: :carpool,
    adapter: Ecto.Adapters.MyXQL
end

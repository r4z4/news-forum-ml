defmodule NewsForum.Repo do
  use Ecto.Repo,
    otp_app: :news_forum,
    adapter: Ecto.Adapters.Postgres
end

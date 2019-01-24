defmodule FeedApi.Repo do
  use Ecto.Repo,
    otp_app: :feed_api,
    adapter: Ecto.Adapters.Postgres
end

defmodule FeedApiWeb.LobsterController do
  use FeedApiWeb, :controller

  alias FeedApi.Lobster

  def index(conn, _params) do
    items = Lobster.get_latest()

    render(conn, "index.json", lobsters: items)
  end
end

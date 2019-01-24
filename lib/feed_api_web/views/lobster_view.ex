defmodule FeedApiWeb.LobsterView do
  use FeedApiWeb, :view
  alias FeedApiWeb.LobsterView

  def render("index.json", %{lobsters: lobsters}) do
    %{data: render_many(lobsters, LobsterView, "lobster.json")}
  end

  def render("show.json", %{lobster: lobster}) do
    %{data: render_one(lobster, LobsterView, "lobster.json")}
  end

  def render("lobster.json", %{lobster: lobster}) do
    %{
      id: lobster.id,
      url: lobster.url,
      title: lobster.title,
      author: lobster.author,
      date_published: lobster.date_published,
      comments: lobster.comments,
      vote_number: lobster.vote_number
    }
  end
end

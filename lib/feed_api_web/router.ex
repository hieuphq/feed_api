defmodule FeedApiWeb.Router do
  use FeedApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", FeedApiWeb do
    pipe_through :api

    get "/lobsters", LobsterController, :index
  end
end

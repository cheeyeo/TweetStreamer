defmodule TwitterPlayground.Router do
  use TwitterPlayground.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug TwitterPlayground.ChannelsNav, repo: TwitterPlayground.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TwitterPlayground do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/channels", ChannelController, only: [:index, :new, :show, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TwitterPlayground do
  #   pipe_through :api
  # end
end

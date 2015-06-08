defmodule ElixirExtract.Router do
  use ElixirExtract.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirExtract do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ElixirExtract do
    pipe_through :api

    resources "/articles", ArticleController
  end
end

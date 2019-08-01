defmodule RaggedWeb.Router do
  use RaggedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RaggedWeb do
    pipe_through :browser

    get "/",       HomeController, :index
    get "/login",  HomeController, :login
    get "/signup", HomeController, :signup
    get "/abt",    HomeController, :about

    live "/demo", Demo
    live "/news", News
  end

  scope "/api", RaggedWeb do
    pipe_through :api
  end
end

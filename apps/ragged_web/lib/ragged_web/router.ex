defmodule RaggedWeb.Router do
  use RaggedWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
    plug RaggedWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RaggedWeb do
    pipe_through :browser

    get  "/",       HomeController,  :index
    get  "/login",  HomeController,  :login
    get  "/signup", HomeController,  :signup
    get  "/about",  HomeController,  :about
    get  "/subs",   HomeController,  :subs
    get  "/demo",   HomeController,  :demo
    get  "/news",   NewsController,  :index
    live "/demo1",  Live.Demo1
    live "/demo2",  Live.Demo2
    get  "/demo3",  Demo3Controller, :index

    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

  end

  scope "/api", RaggedWeb do
    pipe_through :api
  end
end

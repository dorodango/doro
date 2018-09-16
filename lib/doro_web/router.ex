defmodule DoroWeb.Router do
  use DoroWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DoroWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api", DoroWeb do
    pipe_through(:api)
    get("/entities", Api.EntitiesController, :index)
    put("/entities", Api.EntitiesController, :create)
    delete("/entities/:id", Api.EntitiesController, :destroy)
    get("/behaviors", Api.BehaviorsController, :index)
  end
end

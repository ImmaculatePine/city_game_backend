defmodule CityGameBackendWeb.Router do
  use CityGameBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CityGameBackendWeb do
    pipe_through :api
  end
end

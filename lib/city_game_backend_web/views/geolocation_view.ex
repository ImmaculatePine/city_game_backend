defmodule CityGameBackendWeb.GeolocationView do
  use CityGameBackendWeb, :view

  def render("geolocation.json", %{geolocation: geolocation}),
    do: Map.take(geolocation, [:id, :lat, :lon])
end

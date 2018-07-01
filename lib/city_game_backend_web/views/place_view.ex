defmodule CityGameBackendWeb.PlaceView do
  use CityGameBackendWeb, :view
  alias CityGameBackendWeb.{PlaceView, GeolocationView}
  alias Ecto.Association.NotLoaded

  def render("index.json", %{places: places}) do
    %{data: render_many(places, PlaceView, "place.json")}
  end

  def render("show.json", %{place: place}) do
    %{data: render_one(place, PlaceView, "place.json")}
  end

  def render("place.json", %{place: place}) do
    place
    |> Map.take([:id, :name, :address])
    |> maybe_add_geolocation(place)
  end

  defp maybe_add_geolocation(view, %{geolocation: %NotLoaded{}}), do: view

  defp maybe_add_geolocation(view, %{geolocation: geolocation}) do
    Map.put(view, :geolocation, render_one(geolocation, GeolocationView, "geolocation.json"))
  end
end

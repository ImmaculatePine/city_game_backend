defmodule CityGameBackendWeb.WaypointView do
  use CityGameBackendWeb, :view
  alias CityGameBackendWeb.{WaypointView, PlaceView}
  alias Ecto.Association.NotLoaded

  def render("index.json", %{waypoints: waypoints}) do
    %{data: render_many(waypoints, WaypointView, "waypoint.json")}
  end

  def render("show.json", %{waypoint: waypoint}) do
    %{data: render_one(waypoint, WaypointView, "waypoint.json")}
  end

  def render("waypoint.json", %{waypoint: %{place: %NotLoaded{}} = waypoint}) do
    %{id: waypoint.id, position: waypoint.position, place_id: waypoint.place_id}
  end

  def render("waypoint.json", %{waypoint: %{place: place} = waypoint}) do
    %{
      id: waypoint.id,
      position: waypoint.position,
      place: render_one(place, PlaceView, "place.json")
    }
  end
end

defmodule CityGameBackendWeb.WaypointView do
  use CityGameBackendWeb, :view
  alias CityGameBackendWeb.WaypointView

  def render("index.json", %{waypoints: waypoints}) do
    %{data: render_many(waypoints, WaypointView, "waypoint.json")}
  end

  def render("show.json", %{waypoint: waypoint}) do
    %{data: render_one(waypoint, WaypointView, "waypoint.json")}
  end

  def render("waypoint.json", %{waypoint: waypoint}) do
    %{id: waypoint.id, position: waypoint.position}
  end
end

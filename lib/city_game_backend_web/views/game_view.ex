defmodule CityGameBackendWeb.GameView do
  use CityGameBackendWeb, :view
  alias CityGameBackendWeb.{GameView, WaypointView}
  alias Ecto.Association.NotLoaded

  def render("index.json", %{games: games}) do
    %{data: render_many(games, GameView, "game.json")}
  end

  def render("show.json", %{game: game}) do
    %{data: render_one(game, GameView, "game.json")}
  end

  def render("game.json", %{game: %{waypoints: %NotLoaded{}} = game}) do
    %{id: game.id, name: game.name}
  end

  def render("game.json", %{game: %{waypoints: waypoints} = game}) do
    %{
      id: game.id,
      name: game.name,
      waypoints: render_many(waypoints, WaypointView, "waypoint.json")
    }
  end
end

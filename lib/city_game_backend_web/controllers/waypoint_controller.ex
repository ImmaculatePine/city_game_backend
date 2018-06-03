defmodule CityGameBackendWeb.WaypointController do
  use CityGameBackendWeb, :controller

  alias CityGameBackend.Games
  alias CityGameBackend.Games.Waypoint

  action_fallback(CityGameBackendWeb.FallbackController)

  def index(conn, %{"game_id" => game_id}) do
    waypoints = Games.list_waypoints(game_id)
    render(conn, "index.json", waypoints: waypoints)
  end

  def create(conn, %{"game_id" => game_id, "waypoint" => waypoint_params}) do
    with attrs = Map.put(waypoint_params, "game_id", game_id),
         {:ok, %Waypoint{} = waypoint} <- Games.create_waypoint(attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", waypoint: waypoint)
    end
  end

  def delete(conn, %{"id" => id}) do
    waypoint = Games.get_waypoint!(id)

    with {:ok, %Waypoint{}} <- Games.delete_waypoint(waypoint) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule CityGameBackendWeb.WaypointControllerTest do
  import CityGameBackend.Factory

  use CityGameBackendWeb.ConnCase

  alias CityGameBackend.Games

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all waypoints", %{conn: conn} do
      %{id: game_id} = insert(:game_no_waypoints)
      conn = get(conn, game_waypoint_path(conn, :index, game_id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create waypoint" do
    test "renders waypoint when data is valid", %{conn: conn} do
      %{id: game_id} = insert(:game_no_waypoints)
      %{id: place_id} = insert(:place)

      conn =
        post(
          conn,
          game_waypoint_path(conn, :create, game_id),
          waypoint: %{position: 1, place_id: place_id}
        )

      assert %{"id" => _, "position" => 1} = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      %{id: game_id} = insert(:game_no_waypoints)
      conn = post(conn, game_waypoint_path(conn, :create, game_id), waypoint: %{})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete waypoint" do
    test "deletes chosen waypoint", %{conn: conn} do
      %{id: game_id, waypoints: [%{id: waypoint_id} | _]} = insert(:game)
      conn = delete(conn, game_waypoint_path(conn, :delete, game_id, waypoint_id))
      assert response(conn, 204)
      assert_raise Ecto.NoResultsError, fn -> Games.get_waypoint!(waypoint_id) end
    end
  end
end

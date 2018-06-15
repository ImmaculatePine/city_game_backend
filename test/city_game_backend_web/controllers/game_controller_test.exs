defmodule CityGameBackendWeb.GameControllerTest do
  import CityGameBackend.Factory

  use CityGameBackendWeb.ConnCase

  alias CityGameBackend.Games.Game

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "renders empty list when there are no games", %{conn: conn} do
      conn = get(conn, game_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all games", %{conn: conn} do
      %{id: id, name: name} = insert(:game)
      conn = get(conn, game_path(conn, :index))

      assert json_response(conn, 200)["data"] == [%{"id" => id, "name" => name}]
    end
  end

  describe "show" do
    test "renders a game with a list of waypoints and places", %{conn: conn} do
      {:ok, game: %{id: id, name: name}} = create_game(conn)
      conn = get(conn, game_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => ^name,
               "waypoints" => [
                 %{
                   "id" => _,
                   "position" => _,
                   "place" => %{"id" => _, "name" => _, "address" => _}
                 },
                 %{
                   "id" => _,
                   "position" => _,
                   "place" => %{"id" => _, "name" => _, "address" => _}
                 },
                 %{
                   "id" => _,
                   "position" => _,
                   "place" => %{"id" => _, "name" => _, "address" => _}
                 }
               ]
             } = json_response(conn, 200)["data"]
    end
  end

  describe "create game" do
    test "renders game when data is valid", %{conn: conn} do
      conn = post(conn, game_path(conn, :create), game: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, game_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "name" => "some name",
               "waypoints" => []
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, game_path(conn, :create), game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update game" do
    setup [:create_game]

    test "renders game when data is valid", %{conn: conn, game: %Game{id: id} = game} do
      conn = put(conn, game_path(conn, :update, game), game: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, game_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name",
               "waypoints" => [
                 %{"id" => _, "place" => %{"id" => _}},
                 %{"id" => _, "place" => %{"id" => _}},
                 %{"id" => _, "place" => %{"id" => _}}
               ]
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, game: game} do
      conn = put(conn, game_path(conn, :update, game), game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{conn: conn, game: game} do
      conn = delete(conn, game_path(conn, :delete, game))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, game_path(conn, :show, game))
      end)
    end
  end

  defp create_game(_) do
    game = insert(:game)
    {:ok, game: game}
  end
end

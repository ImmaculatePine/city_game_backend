defmodule CityGameBackend.GamesTest do
  import CityGameBackend.Factory

  use CityGameBackend.DataCase

  alias CityGameBackend.Games
  alias CityGameBackend.Games.{Game, Waypoint}
  alias CityGameBackend.Places.Place

  describe "games" do
    test "list_games/0 returns all games without preloaded waypoints" do
      %{id: id} = insert(:game)
      assert [%{id: ^id, waypoints: %Ecto.Association.NotLoaded{}}] = Games.list_games()
    end

    test "get_game!/1 returns the selected game with preloaded waypoints and places" do
      %{id: id, name: name, waypoints: waypoints} = insert(:game)

      [%{id: waypoint_id, position: position, place: %{id: place_id}}, _, _] =
        Enum.sort_by(waypoints, & &1.id)

      assert %Game{id: ^id, name: ^name, waypoints: [waypoint, _, _]} = Games.get_game!(id)

      assert %Waypoint{
               id: ^waypoint_id,
               game_id: ^id,
               position: ^position,
               place: %Place{id: ^place_id}
             } = waypoint
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Games.create_game(%{name: "some name"})
      assert game.name == "some name"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(%{name: nil})
    end

    test "update_game/2 with valid data updates the game" do
      game = insert(:game)

      assert {:ok, game} = Games.update_game(game, %{name: "some updated name"})
      assert %Game{} = game
      assert game.name == "some updated name"
    end

    test "update_game/2 with invalid data returns error changeset" do
      %{id: id, name: name} = game = insert(:game)

      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, %{name: nil})
      assert %Game{name: ^name} = Games.get_game!(id)
    end

    test "delete_game/1 deletes the game" do
      game = insert(:game)

      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = insert(:game)

      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end

  describe "waypoints" do
    test "list_waypoints/1 returns all waypoints of the game" do
      %{id: game_id, waypoints: waypoints} = insert(:game)

      assert game_id |> Games.list_waypoints() |> Enum.map(& &1.id) ==
               Enum.map(waypoints, & &1.id)
    end

    test "get_waypoint!/1 returns the waypoint with given id" do
      %{id: game_id, waypoints: [%{id: id, position: position, place_id: place_id} | _]} =
        insert(:game)

      assert %{id: ^id, position: ^position, game_id: ^game_id, place_id: ^place_id} =
               Games.get_waypoint!(id)
    end

    test "create_waypoint/1 with valid data creates a waypoint" do
      %{id: game_id} = insert(:game_no_waypoints)
      %{id: place_id} = insert(:place)

      assert {:ok, %Waypoint{} = waypoint} =
               Games.create_waypoint(%{game_id: game_id, place_id: place_id, position: 1})

      assert %{position: 1, game_id: ^game_id, place_id: ^place_id} = waypoint
    end

    test "create_waypoint/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{errors: errors}} = Games.create_waypoint(%{})

      assert errors == [
               game_id: {"can't be blank", [validation: :required]},
               place_id: {"can't be blank", [validation: :required]},
               position: {"can't be blank", [validation: :required]}
             ]
    end

    test "delete_waypoint/1 deletes the waypoint" do
      %{id: game_id, waypoints: [waypoint | rest_waypoints]} = insert(:game)
      assert {:ok, %Waypoint{}} = Games.delete_waypoint(waypoint)
      assert_raise Ecto.NoResultsError, fn -> Games.get_waypoint!(waypoint.id) end
      assert game_id |> Games.list_waypoints() |> length == length(rest_waypoints)
    end
  end
end

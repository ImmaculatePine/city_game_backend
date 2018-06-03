defmodule CityGameBackend.GamesTest do
  import CityGameBackend.Factory

  use CityGameBackend.DataCase

  alias CityGameBackend.Games

  describe "games" do
    alias CityGameBackend.Games.Game

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Games.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Games.create_game(@valid_attrs)
      assert game.name == "some name"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Games.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.name == "some updated name"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end

  describe "waypoints" do
    alias CityGameBackend.Games.Waypoint

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

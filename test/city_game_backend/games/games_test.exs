defmodule CityGameBackend.GamesTest do
  import CityGameBackend.Factory

  use CityGameBackend.DataCase

  alias CityGameBackend.Games
  alias CityGameBackend.Games.{Game, Waypoint}
  alias CityGameBackend.Places.Place

  describe "list_games/0" do
    test "returns all games without preloaded waypoints" do
      %{id: id} = insert(:game)
      assert [%{id: ^id, waypoints: %Ecto.Association.NotLoaded{}}] = Games.list_games()
    end
  end

  describe "get_game!/1" do
    test "returns the selected game with preloaded waypoints and places" do
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
  end

  describe "create_game/1" do
    test "creates a game with valid data" do
      assert {:ok, %Game{} = game} = Games.create_game(%{name: "some name"})
      assert game.name == "some name"
    end

    test "returns error changeset with invalid data" do
      assert {:error, %Ecto.Changeset{errors: errors}} = Games.create_game(%{name: nil})
      assert [name: {"can't be blank", [validation: :required]}] == errors
    end
  end

  describe "update_game/2" do
    test "updates the game with valid data" do
      game = insert(:game)

      assert {:ok, game} = Games.update_game(game, %{name: "some updated name"})
      assert %Game{} = game
      assert game.name == "some updated name"
    end

    test "returns error changeset with invalid data" do
      %{id: id, name: name} = game = insert(:game)

      assert {:error, %Ecto.Changeset{errors: errors}} = Games.update_game(game, %{name: nil})
      assert [name: {"can't be blank", [validation: :required]}] == errors
      assert %Game{name: ^name} = Games.get_game!(id)
    end

    test "allows to reorder waypoints" do
      %{id: id, waypoints: waypoints} = game = insert(:game)

      [
        %{id: waypoint_1_id, position: position_1},
        %{id: waypoint_2_id, position: position_2},
        %{id: waypoint_3_id, position: position_3}
      ] = waypoints

      {:ok, %Game{id: ^id}} =
        Games.update_game(game, %{
          waypoints: [
            %{id: waypoint_1_id, position: position_3},
            %{id: waypoint_2_id, position: position_1},
            %{id: waypoint_3_id, position: position_2}
          ]
        })

      assert %{
               waypoints: [
                 %{id: ^waypoint_1_id, position: ^position_3},
                 %{id: ^waypoint_2_id, position: ^position_1},
                 %{id: ^waypoint_3_id, position: ^position_2}
               ]
             } = Games.get_game!(id)
    end

    test "does not allow to change waypoint place" do
      %{id: new_place_id} = insert(:place)
      %{id: id, waypoints: waypoints} = game = insert(:game)

      [
        %{id: waypoint_1_id, position: position_1, place_id: place_1_id},
        %{id: waypoint_2_id, position: position_2, place_id: place_2_id},
        %{id: waypoint_3_id, position: position_3, place_id: place_3_id}
      ] = waypoints

      {:ok, %Game{id: ^id}} =
        Games.update_game(game, %{
          waypoints: [
            %{id: waypoint_1_id, position: position_1, place_id: new_place_id},
            %{id: waypoint_2_id, position: position_2, place_id: place_2_id},
            %{id: waypoint_3_id, position: position_3, place_id: place_3_id}
          ]
        })

      assert %{
               waypoints: [
                 %{id: ^waypoint_1_id, place_id: ^place_1_id},
                 %{id: ^waypoint_2_id, place_id: ^place_2_id},
                 %{id: ^waypoint_3_id, place_id: ^place_3_id}
               ]
             } = Games.get_game!(id)
    end

    test "validates uniqueness of waypoints positions" do
      %{waypoints: [%{id: waypoint_1_id}, %{id: waypoint_2_id}, %{id: waypoint_3_id}]} =
        game = insert(:game)

      {:error, %Ecto.Changeset{errors: errors}} =
        Games.update_game(game, %{
          waypoints: [
            %{id: waypoint_1_id, position: 0},
            %{id: waypoint_2_id, position: 1},
            %{id: waypoint_3_id, position: 1}
          ]
        })

      assert [waypoints: {"should have unique positions", []}] == errors
    end
  end

  describe "delete_game/1" do
    test "deletes the game" do
      game = insert(:game)

      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end
  end

  describe "list_waypoints/1" do
    test "returns all waypoints of the game" do
      %{id: game_id, waypoints: waypoints} = insert(:game)

      assert game_id |> Games.list_waypoints() |> Enum.map(& &1.id) ==
               Enum.map(waypoints, & &1.id)
    end
  end

  describe "get_waypoint!/1" do
    test "returns the waypoint with given id" do
      %{id: game_id, waypoints: [%{id: id, position: position, place_id: place_id} | _]} =
        insert(:game)

      assert %{id: ^id, position: ^position, game_id: ^game_id, place_id: ^place_id} =
               Games.get_waypoint!(id)
    end
  end

  describe "create_waypoint/1" do
    test "creates a waypoint with valid data" do
      %{id: game_id} = insert(:game_no_waypoints)
      %{id: place_id} = insert(:place)

      assert {:ok, %Waypoint{} = waypoint} =
               Games.create_waypoint(%{game_id: game_id, place_id: place_id, position: 1})

      assert %{position: 1, game_id: ^game_id, place_id: ^place_id} = waypoint
    end

    test "returns error changeset with invalid data" do
      assert {:error, %Ecto.Changeset{errors: errors}} = Games.create_waypoint(%{})

      assert [
               game_id: {"can't be blank", [validation: :required]},
               place_id: {"can't be blank", [validation: :required]},
               position: {"can't be blank", [validation: :required]}
             ] == errors
    end
  end

  describe "delete_waypoint/1" do
    test "deletes the waypoint" do
      %{id: game_id, waypoints: [waypoint | rest_waypoints]} = insert(:game)

      assert {:ok, %Waypoint{}} = Games.delete_waypoint(waypoint)
      assert_raise Ecto.NoResultsError, fn -> Games.get_waypoint!(waypoint.id) end
      assert game_id |> Games.list_waypoints() |> length == length(rest_waypoints)
    end
  end
end

defmodule CityGameBackend.PlacesTest do
  use CityGameBackend.DataCase

  import CityGameBackend.Factory

  alias CityGameBackend.Places
  alias CityGameBackend.Places.Place

  describe "get_place!/1" do
    test "returns the place with given id" do
      %{id: id, name: name, address: address} = insert(:place)

      assert %Place{
               id: ^id,
               name: ^name,
               address: ^address,
               geolocation: nil
             } = Places.get_place!(id)
    end

    test "returns the place with given id and preloaded geolocation" do
      %{id: id, name: name, address: address} = place = insert(:place)
      %{id: geolocation_id, lat: lat, lon: lon} = insert(:geolocation, place: place)

      assert %Place{
               id: ^id,
               name: ^name,
               address: ^address,
               geolocation: %{
                 id: ^geolocation_id,
                 lat: ^lat,
                 lon: ^lon
               }
             } = Places.get_place!(id)
    end
  end

  describe "places" do
    @valid_attrs %{address: "some address", name: "some name"}
    @update_attrs %{address: "some updated address", name: "some updated name"}
    @invalid_attrs %{address: nil, name: nil}

    def place_fixture(attrs \\ %{}) do
      {:ok, place} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Places.create_place()

      place
    end

    test "list_places/0 returns all places" do
      place = place_fixture()
      assert Places.list_places() == [place]
    end

    test "create_place/1 with valid data creates a place" do
      assert {:ok, %Place{} = place} = Places.create_place(@valid_attrs)
      assert place.address == "some address"
      assert place.name == "some name"
    end

    test "create_place/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Places.create_place(@invalid_attrs)
    end

    test "update_place/2 with valid data updates the place" do
      place = place_fixture()
      assert {:ok, place} = Places.update_place(place, @update_attrs)
      assert %Place{} = place
      assert place.address == "some updated address"
      assert place.name == "some updated name"
    end

    test "update_place/2 with invalid data returns error changeset" do
      %{id: id, name: name, address: address} = place = insert(:place)
      assert {:error, %Ecto.Changeset{}} = Places.update_place(place, @invalid_attrs)
      assert %{name: ^name, address: ^address} = Places.get_place!(id)
    end

    test "delete_place/1 deletes the place" do
      place = place_fixture()
      assert {:ok, %Place{}} = Places.delete_place(place)
      assert_raise Ecto.NoResultsError, fn -> Places.get_place!(place.id) end
    end

    test "change_place/1 returns a place changeset" do
      place = place_fixture()
      assert %Ecto.Changeset{} = Places.change_place(place)
    end
  end
end

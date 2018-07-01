defmodule CityGameBackend.Maps.LookupTest do
  import CityGameBackend.Factory
  import Mock

  use CityGameBackend.DataCase

  alias CityGameBackend.Places
  alias CityGameBackend.Maps.{Lookup, Geolocation}
  alias Googleapis.Maps.Geocoding

  @lat 52.413108
  @lon 16.9040789
  @geolocation_response {:ok, [%{"geometry" => %{"location" => %{"lat" => @lat, "lng" => @lon}}}]}

  describe "lookup/1" do
    test "creates new geolocation for a place" do
      %{id: place_id} = place = insert(:place)

      with_mock Geocoding, call: fn _ -> @geolocation_response end do
        Lookup.lookup(place)
        assert %{geolocation: %Geolocation{lat: @lat, lon: @lon}} = Places.get_place!(place_id)
      end
    end

    test "updates an exising geolocation" do
      %{id: place_id} = place = insert(:place)
      %{id: geolocation_id} = insert(:geolocation, place: place, lat: 50.123, lon: 16.123)

      with_mock Geocoding, call: fn _ -> @geolocation_response end do
        Lookup.lookup(place)

        assert %{geolocation: %Geolocation{id: ^geolocation_id, lat: @lat, lon: @lon}} =
                 Places.get_place!(place_id)
      end
    end
  end
end

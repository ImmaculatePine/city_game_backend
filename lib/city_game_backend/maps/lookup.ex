defmodule CityGameBackend.Maps.Lookup do
  alias CityGameBackend.Places
  alias CityGameBackend.Places.Place
  alias Googleapis.Maps.Geocoding

  def start_link(%Place{} = place) do
    Task.start_link(__MODULE__, :lookup, [place])
  end

  def lookup(%Place{id: id, address: address}) do
    with {:ok, [geolocation]} <- Geocoding.call(address) do
      geolocation
      |> get_coordinates()
      |> upsert_geolocation(id)
    end
  end

  defp get_coordinates(%{"geometry" => %{"location" => %{"lat" => lat, "lng" => lon}}}) do
    %{
      lat: lat,
      lon: lon
    }
  end

  defp upsert_geolocation(coordinates, place_id) do
    place_id
    |> Places.get_place!()
    |> Places.update_place(%{geolocation: coordinates})
  end
end

defmodule CityGameBackend.Factory do
  use ExMachina.Ecto, repo: CityGameBackend.Repo

  @waypoints_count 3

  def place_factory do
    %CityGameBackend.Places.Place{
      name: sequence(:name, &"Place #{&1}"),
      address: sequence(:address, &"Street #{&1}")
    }
  end

  def game_no_waypoints_factory do
    %CityGameBackend.Games.Game{
      name: sequence(:name, &"City Game #{&1}")
    }
  end

  def game_factory do
    struct!(game_no_waypoints_factory(), %{waypoints: build_list(@waypoints_count, :waypoint)})
  end

  def waypoint_factory do
    %CityGameBackend.Games.Waypoint{
      place: build(:place),
      position: sequence(:waypoint_position, & &1)
    }
  end

  def geolocation_factory do
    %CityGameBackend.Maps.Geolocation{
      place: build(:place),
      lat: 52.413108,
      lon: 16.9040789
    }
  end
end

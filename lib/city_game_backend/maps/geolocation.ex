defmodule CityGameBackend.Maps.Geolocation do
  use Ecto.Schema
  import Ecto.Changeset
  alias CityGameBackend.Places.Place

  schema "geolocations" do
    field(:lat, :float)
    field(:lon, :float)

    belongs_to(:place, Place)

    timestamps()
  end

  @doc false
  def changeset(geolocation, attrs) do
    geolocation
    |> cast(attrs, [:lat, :lon])
    |> validate_required([:lat, :lon])
  end
end

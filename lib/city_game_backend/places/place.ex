defmodule CityGameBackend.Places.Place do
  use Ecto.Schema
  import Ecto.Changeset
  alias CityGameBackend.Maps.Geolocation

  schema "places" do
    field(:address, :string)
    field(:name, :string)

    has_one(:geolocation, Geolocation, on_delete: :delete_all, on_replace: :update)

    timestamps()
  end

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
    |> cast_assoc(:geolocation)
  end
end

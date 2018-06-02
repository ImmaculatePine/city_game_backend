defmodule CityGameBackend.Places.Place do
  use Ecto.Schema
  import Ecto.Changeset

  schema "places" do
    field(:address, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
  end
end

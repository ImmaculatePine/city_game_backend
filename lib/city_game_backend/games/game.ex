defmodule CityGameBackend.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias CityGameBackend.Games.Waypoint

  schema "games" do
    field(:name, :string)

    has_many(:waypoints, Waypoint)

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

defmodule CityGameBackend.Games.Waypoint do
  use Ecto.Schema
  import Ecto.Changeset

  alias CityGameBackend.Games.Game
  alias CityGameBackend.Places.Place

  schema "waypoints" do
    field(:position, :integer)

    belongs_to(:game, Game)
    belongs_to(:place, Place)

    timestamps()
  end

  def create_changeset(waypoint, attrs) do
    waypoint
    |> cast(attrs, [:game_id, :place_id, :position])
    |> validate_required([:game_id, :place_id, :position])
    |> assoc_constraint(:game)
    |> assoc_constraint(:place)
  end

  def update_changeset(waypoint, attrs) do
    waypoint
    |> cast(attrs, [:position])
    |> validate_required(:position)
  end
end

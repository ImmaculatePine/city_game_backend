defmodule CityGameBackend.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias CityGameBackend.Games.Waypoint

  schema "games" do
    field(:name, :string)

    has_many(:waypoints, Waypoint, on_delete: :delete_all, on_replace: :delete)

    timestamps()
  end

  def create_changeset(game, attrs) do
    game
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def update_changeset(game, attrs) do
    game
    |> create_changeset(attrs)
    |> cast_assoc(:waypoints, with: &Waypoint.update_changeset/2)
    |> validate_waypoints_positions()
  end

  defp validate_waypoints_positions(changeset) do
    validate_change(changeset, :waypoints, fn :waypoints, waypoints ->
      waypoints
      |> Enum.reject(&(&1.action == :replace))
      |> extract_positions()
      |> check_uniqueness()
    end)
  end

  defp extract_positions(changeset), do: Enum.map(changeset, &get_field(&1, :position))

  defp check_uniqueness(positions) do
    positions
    |> Enum.uniq()
    |> maybe_uniq(positions)
  end

  defp maybe_uniq(positions, positions), do: []

  defp maybe_uniq(_positions, _other_positions),
    do: [{:waypoints, "should have unique positions"}]
end

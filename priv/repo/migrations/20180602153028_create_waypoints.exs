defmodule CityGameBackend.Repo.Migrations.CreateWaypoints do
  use Ecto.Migration

  def change do
    create table(:waypoints) do
      add :position, :integer, null: false
      add :game_id, references(:games, on_delete: :delete_all)
      add :place_id, references(:places, on_delete: :delete_all)

      timestamps()
    end

    create index(:waypoints, [:game_id])
    create index(:waypoints, [:place_id])
    create unique_index(:waypoints, [:game_id, :place_id])
  end
end

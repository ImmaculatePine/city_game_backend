defmodule CityGameBackend.Repo.Migrations.CreateGeolocations do
  use Ecto.Migration

  def change do
    create table(:geolocations) do
      add :lat, :float
      add :lon, :float
      add :place_id, references(:places, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:geolocations, [:place_id])
  end
end

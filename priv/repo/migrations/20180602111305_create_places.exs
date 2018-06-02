defmodule CityGameBackend.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :address, :text

      timestamps()
    end

  end
end

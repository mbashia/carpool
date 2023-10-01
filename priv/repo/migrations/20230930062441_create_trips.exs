defmodule Carpool.Repo.Migrations.CreateTrips do
  use Ecto.Migration

  def change do
    create table(:trips) do
      add :from, :string
      add :to, :string
      add :capacity, :string
      add :notes, :string
      add :price, :string
      add :user_id, :integer
      add :longitude_to, :float
      add :latitude_to, :float
      add :longitude_from, :float
      add :latitude_from, :float
      add :departure_time, :time
      add :return_time, :time

      timestamps()
    end

    create index(:trips, [:user_id])
  end
end

defmodule Carpool.Repo.Migrations.CreateTrips do
  use Ecto.Migration

  def change do
    create table(:trips) do
      add :from, :string
      add :to, :string
      add :capacity, :string
      add :notes, :string
      add :price, :string

      timestamps()
    end
  end
end

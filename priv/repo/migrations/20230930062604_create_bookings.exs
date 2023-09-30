defmodule Carpool.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :status, :string
      add :location, :string
      add :notes, :string

      timestamps()
    end
  end
end

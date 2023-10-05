defmodule Carpool.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :phone_number, :string
      add :location_from, :string
      add :location_to, :string
      add :booking_latitude_to, :float
      add :booking_longitude_to, :float
      add :booking_latitude_from, :float
      add :booking_longitude_from, :float
      add :notes, :string
      add :user_id, :integer
      add :trip_id, :integer

      timestamps()
    end

    create index(:bookings, [:user_id, :trip_id])
  end
end

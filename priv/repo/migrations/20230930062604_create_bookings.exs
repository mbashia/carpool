defmodule Carpool.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :status, :string
      add :location, :string
      add :notes, :string
      add :user_id, :integer

      timestamps()
    end
    create index(:bookings, [:user_id])
  end
end

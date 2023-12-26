defmodule Carpool.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:image) do
      add :image_url, :string

      timestamps()
    end
  end
end

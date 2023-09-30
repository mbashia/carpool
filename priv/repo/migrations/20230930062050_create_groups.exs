defmodule Carpool.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :description, :string
      add :user_id, :integer

      timestamps()
    end

    create index(:groups, [:user_id])
  end
end

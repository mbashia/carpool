defmodule Carpool.Repo.Migrations.CreateGroupMessages do
  use Ecto.Migration

  def change do
    create table(:group_messages) do
      add :text, :string

      timestamps()
    end
  end
end

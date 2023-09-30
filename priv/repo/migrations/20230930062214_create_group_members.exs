defmodule Carpool.Repo.Migrations.CreateGroupMembers do
  use Ecto.Migration

  def change do
    create table(:group_members) do
      add :user_id, :string
      add :group_id, :string

      timestamps()
    end
  end
end

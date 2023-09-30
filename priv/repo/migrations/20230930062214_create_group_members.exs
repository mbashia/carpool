defmodule Carpool.Repo.Migrations.CreateGroupMembers do
  use Ecto.Migration

  def change do
    create table(:group_members) do
      add :user_id, :integer
      add :group_id, :integer

      timestamps()
    end
  end
end

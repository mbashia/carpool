defmodule Carpool.Repo.Migrations.CreateGroupMessages do
  use Ecto.Migration

  def change do
    create table(:group_messages) do
      add :text, :string
      add :sender_id, :integer
      add :group_id, :integer

      timestamps()
    end

    create index(:group_messages, [:sender_id])
  end
end

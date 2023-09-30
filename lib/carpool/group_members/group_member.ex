defmodule Carpool.Group_members.Group_member do
  use Ecto.Schema
  import Ecto.Changeset
  alias Carpool.Accounts.User
  alias Carpool.Groups.Group

  schema "group_members" do
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :group, Group, foreign_key: :group_id

    timestamps()
  end

  @doc false
  def changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [:user_id, :group_id])
    |> validate_required([:user_id, :group_id])
  end
end

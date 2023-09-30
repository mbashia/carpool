defmodule Carpool.Group_members.Group_member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_members" do
    field :group_id, :string
    field :user_id, :string

    timestamps()
  end

  @doc false
  def changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [:user_id, :group_id])
    |> validate_required([:user_id, :group_id])
  end
end

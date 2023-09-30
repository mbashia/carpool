defmodule Carpool.Group_messages.Group_message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Carpool.Accounts.User
  alias Carpool.Groups.Group

  schema "group_messages" do
    field :text, :string
    belongs_to :user, User, foreign_key: :sender_id
    belongs_to :group, Group, foreign_key: :group_id

    timestamps()
  end

  @doc false
  def changeset(group_message, attrs) do
    group_message
    |> cast(attrs, [:text, :sender_id, :group_id])
    |> validate_required([:text, :sender_id, :group_id])
  end
end

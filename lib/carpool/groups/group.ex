defmodule Carpool.Groups.Group do
  use Ecto.Schema
  import Ecto.Changeset
  alias Carpool.Accounts.User
  alias Carpool.Group_messages.Group_message

  schema "groups" do
    field :description, :string
    field :name, :string
    belongs_to :user, User, foreign_key: :user_id
    has_many :group_messages, Group_message

    timestamps()
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :description, :user_id])
  end
end

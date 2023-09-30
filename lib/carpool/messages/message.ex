defmodule Carpool.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Carpool.Accounts.User

  schema "messages" do
    field :text, :string
    belongs_to :user, User, foreign_key: :sender_id
    field :receiver_id, :integer


    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text,:sender_id, :receiver_id])
    |> validate_required([:text , :sender_id, :receiver_id])
  end
end

defmodule Carpool.Trips.Trip do
  use Ecto.Schema
  import Ecto.Changeset
  alias Carpool.Accounts.User

  schema "trips" do
    field :capacity, :string
    field :from, :string
    field :notes, :string
    field :price, :string
    field :to, :string
    belongs_to :user, User, foreign_key: :user_id


    timestamps()
  end

  @doc false
  def changeset(trip, attrs) do
    trip
    |> cast(attrs, [:from, :to, :capacity, :notes, :price, :user_id])
    |> validate_required([:from, :to, :capacity, :notes, :price, :user_id])
  end
end

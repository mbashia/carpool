defmodule Carpool.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  alias Carpool.Accounts.User

  schema "bookings" do
    field :location, :string
    field :notes, :string
    field :status, :string
    belongs_to :user, User, foreign_key: :user_id


    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:status, :location, :notes,:user_id])
    |> validate_required([:status, :location, :notes,:user_id])
  end
end

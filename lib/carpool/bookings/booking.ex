defmodule Carpool.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset
  alias Carpool.Accounts.User

  schema "bookings" do
    field :location_to, :string
    field :location_from, :string
    field :booking_latitude_to, :float
    field :booking_longitude_to, :float
    field :booking_latitude_from, :float
    field :booking_longitude_from, :float
    field :notes, :string
    field :subscription, :string
    field :phone_number, :string
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :trip, Trip, foreign_key: :trip_id

    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [
      :phone_number,
      :location_from,
      :location_to,
      :notes,
      :user_id,
      :trip_id,
      :booking_latitude_to,
      :booking_longitude_to,
      :booking_latitude_from,
      :booking_longitude_from,
      :subscription
    ])
    |> validate_required([
      :phone_number,
      :location_from,
      :location_to,
      :notes,
      :user_id,
      :trip_id,
      :booking_latitude_to,
      :booking_longitude_to,
      :booking_latitude_from,
      :booking_longitude_from,
      :subscription
    ])
    |> validate_format(
      :phone_number,
      ~r/^254\d{9}$/,
      message: "Number has to start with 254 and have 12 digits"
    )
  end
end

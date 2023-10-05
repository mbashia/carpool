defmodule Carpool.Trips.Trip do
  use Ecto.Schema
  import Ecto.Changeset
  alias Carpool.Accounts.User

  schema "trips" do
    field :capacity, :string
    field :from, :string
    field :notes, :string

    field :latitude_from, :float
    field :latitude_to, :float
    field :longitude_from, :float
    field :departure_time, :time
    field :return_time, :time
    field :kilometres_per_litre, :string

    field :longitude_to, :float
    field :to, :string
    belongs_to :user, User, foreign_key: :user_id
    has_many :bookings, Carpool.Bookings.Booking

    timestamps()
  end

  @doc false
  def changeset(trip, attrs) do
    trip
    |> cast(attrs, [
      :from,
      :to,
      :capacity,
      :notes,
      :user_id,
      :longitude_to,
      :latitude_to,
      :longitude_from,
      :latitude_from,
      :departure_time,
      :return_time,
      :kilometres_per_litre
    ])
    |> validate_required([
      :from,
      :to,
      :capacity,
      :notes,
      :user_id,
      :longitude_to,
      :latitude_to,
      :longitude_from,
      :latitude_from,
      :departure_time,
      :return_time,
      :kilometres_per_litre
    ])
  end
end

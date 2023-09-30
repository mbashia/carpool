defmodule Carpool.Bookings.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :location, :string
    field :notes, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:status, :location, :notes])
    |> validate_required([:status, :location, :notes])
  end
end

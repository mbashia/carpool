defmodule Carpool.Trips.Trip do
  use Ecto.Schema
  import Ecto.Changeset

  schema "trips" do
    field :capacity, :string
    field :from, :string
    field :notes, :string
    field :price, :string
    field :to, :string

    timestamps()
  end

  @doc false
  def changeset(trip, attrs) do
    trip
    |> cast(attrs, [:from, :to, :capacity, :notes, :price])
    |> validate_required([:from, :to, :capacity, :notes, :price])
  end
end

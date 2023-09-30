defmodule Carpool.TripsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Carpool.Trips` context.
  """

  @doc """
  Generate a trip.
  """
  def trip_fixture(attrs \\ %{}) do
    {:ok, trip} =
      attrs
      |> Enum.into(%{
        capacity: "some capacity",
        from: "some from",
        notes: "some notes",
        price: "some price",
        to: "some to"
      })
      |> Carpool.Trips.create_trip()

    trip
  end
end

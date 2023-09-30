defmodule Carpool.BookingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Carpool.Bookings` context.
  """

  @doc """
  Generate a booking.
  """
  def booking_fixture(attrs \\ %{}) do
    {:ok, booking} =
      attrs
      |> Enum.into(%{
        location: "some location",
        notes: "some notes",
        status: "some status"
      })
      |> Carpool.Bookings.create_booking()

    booking
  end
end

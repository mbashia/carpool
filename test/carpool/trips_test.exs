defmodule Carpool.TripsTest do
  use Carpool.DataCase

  alias Carpool.Trips

  describe "trips" do
    alias Carpool.Trips.Trip

    import Carpool.TripsFixtures

    @invalid_attrs %{capacity: nil, from: nil, notes: nil, price: nil, to: nil}

    test "list_trips/0 returns all trips" do
      trip = trip_fixture()
      assert Trips.list_trips() == [trip]
    end

    test "get_trip!/1 returns the trip with given id" do
      trip = trip_fixture()
      assert Trips.get_trip!(trip.id) == trip
    end

    test "create_trip/1 with valid data creates a trip" do
      valid_attrs = %{capacity: "some capacity", from: "some from", notes: "some notes", price: "some price", to: "some to"}

      assert {:ok, %Trip{} = trip} = Trips.create_trip(valid_attrs)
      assert trip.capacity == "some capacity"
      assert trip.from == "some from"
      assert trip.notes == "some notes"
      assert trip.price == "some price"
      assert trip.to == "some to"
    end

    test "create_trip/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trips.create_trip(@invalid_attrs)
    end

    test "update_trip/2 with valid data updates the trip" do
      trip = trip_fixture()
      update_attrs = %{capacity: "some updated capacity", from: "some updated from", notes: "some updated notes", price: "some updated price", to: "some updated to"}

      assert {:ok, %Trip{} = trip} = Trips.update_trip(trip, update_attrs)
      assert trip.capacity == "some updated capacity"
      assert trip.from == "some updated from"
      assert trip.notes == "some updated notes"
      assert trip.price == "some updated price"
      assert trip.to == "some updated to"
    end

    test "update_trip/2 with invalid data returns error changeset" do
      trip = trip_fixture()
      assert {:error, %Ecto.Changeset{}} = Trips.update_trip(trip, @invalid_attrs)
      assert trip == Trips.get_trip!(trip.id)
    end

    test "delete_trip/1 deletes the trip" do
      trip = trip_fixture()
      assert {:ok, %Trip{}} = Trips.delete_trip(trip)
      assert_raise Ecto.NoResultsError, fn -> Trips.get_trip!(trip.id) end
    end

    test "change_trip/1 returns a trip changeset" do
      trip = trip_fixture()
      assert %Ecto.Changeset{} = Trips.change_trip(trip)
    end
  end
end

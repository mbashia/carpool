defmodule CarpoolWeb.TripLiveTest do
  use CarpoolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Carpool.TripsFixtures

  @create_attrs %{capacity: "some capacity", from: "some from", notes: "some notes", price: "some price", to: "some to"}
  @update_attrs %{capacity: "some updated capacity", from: "some updated from", notes: "some updated notes", price: "some updated price", to: "some updated to"}
  @invalid_attrs %{capacity: nil, from: nil, notes: nil, price: nil, to: nil}

  defp create_trip(_) do
    trip = trip_fixture()
    %{trip: trip}
  end

  describe "Index" do
    setup [:create_trip]

    test "lists all trips", %{conn: conn, trip: trip} do
      {:ok, _index_live, html} = live(conn, Routes.trip_index_path(conn, :index))

      assert html =~ "Listing Trips"
      assert html =~ trip.capacity
    end

    test "saves new trip", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.trip_index_path(conn, :index))

      assert index_live |> element("a", "New Trip") |> render_click() =~
               "New Trip"

      assert_patch(index_live, Routes.trip_index_path(conn, :new))

      assert index_live
             |> form("#trip-form", trip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#trip-form", trip: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.trip_index_path(conn, :index))

      assert html =~ "Trip created successfully"
      assert html =~ "some capacity"
    end

    test "updates trip in listing", %{conn: conn, trip: trip} do
      {:ok, index_live, _html} = live(conn, Routes.trip_index_path(conn, :index))

      assert index_live |> element("#trip-#{trip.id} a", "Edit") |> render_click() =~
               "Edit Trip"

      assert_patch(index_live, Routes.trip_index_path(conn, :edit, trip))

      assert index_live
             |> form("#trip-form", trip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#trip-form", trip: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.trip_index_path(conn, :index))

      assert html =~ "Trip updated successfully"
      assert html =~ "some updated capacity"
    end

    test "deletes trip in listing", %{conn: conn, trip: trip} do
      {:ok, index_live, _html} = live(conn, Routes.trip_index_path(conn, :index))

      assert index_live |> element("#trip-#{trip.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#trip-#{trip.id}")
    end
  end

  describe "Show" do
    setup [:create_trip]

    test "displays trip", %{conn: conn, trip: trip} do
      {:ok, _show_live, html} = live(conn, Routes.trip_show_path(conn, :show, trip))

      assert html =~ "Show Trip"
      assert html =~ trip.capacity
    end

    test "updates trip within modal", %{conn: conn, trip: trip} do
      {:ok, show_live, _html} = live(conn, Routes.trip_show_path(conn, :show, trip))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Trip"

      assert_patch(show_live, Routes.trip_show_path(conn, :edit, trip))

      assert show_live
             |> form("#trip-form", trip: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#trip-form", trip: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.trip_show_path(conn, :show, trip))

      assert html =~ "Trip updated successfully"
      assert html =~ "some updated capacity"
    end
  end
end

defmodule CarpoolWeb.BookingLiveTest do
  use CarpoolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Carpool.BookingsFixtures

  @create_attrs %{location: "some location", notes: "some notes", status: "some status"}
  @update_attrs %{location: "some updated location", notes: "some updated notes", status: "some updated status"}
  @invalid_attrs %{location: nil, notes: nil, status: nil}

  defp create_booking(_) do
    booking = booking_fixture()
    %{booking: booking}
  end

  describe "Index" do
    setup [:create_booking]

    test "lists all bookings", %{conn: conn, booking: booking} do
      {:ok, _index_live, html} = live(conn, Routes.booking_index_path(conn, :index))

      assert html =~ "Listing Bookings"
      assert html =~ booking.location
    end

    test "saves new booking", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.booking_index_path(conn, :index))

      assert index_live |> element("a", "New Booking") |> render_click() =~
               "New Booking"

      assert_patch(index_live, Routes.booking_index_path(conn, :new))

      assert index_live
             |> form("#booking-form", booking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#booking-form", booking: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.booking_index_path(conn, :index))

      assert html =~ "Booking created successfully"
      assert html =~ "some location"
    end

    test "updates booking in listing", %{conn: conn, booking: booking} do
      {:ok, index_live, _html} = live(conn, Routes.booking_index_path(conn, :index))

      assert index_live |> element("#booking-#{booking.id} a", "Edit") |> render_click() =~
               "Edit Booking"

      assert_patch(index_live, Routes.booking_index_path(conn, :edit, booking))

      assert index_live
             |> form("#booking-form", booking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#booking-form", booking: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.booking_index_path(conn, :index))

      assert html =~ "Booking updated successfully"
      assert html =~ "some updated location"
    end

    test "deletes booking in listing", %{conn: conn, booking: booking} do
      {:ok, index_live, _html} = live(conn, Routes.booking_index_path(conn, :index))

      assert index_live |> element("#booking-#{booking.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#booking-#{booking.id}")
    end
  end

  describe "Show" do
    setup [:create_booking]

    test "displays booking", %{conn: conn, booking: booking} do
      {:ok, _show_live, html} = live(conn, Routes.booking_show_path(conn, :show, booking))

      assert html =~ "Show Booking"
      assert html =~ booking.location
    end

    test "updates booking within modal", %{conn: conn, booking: booking} do
      {:ok, show_live, _html} = live(conn, Routes.booking_show_path(conn, :show, booking))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Booking"

      assert_patch(show_live, Routes.booking_show_path(conn, :edit, booking))

      assert show_live
             |> form("#booking-form", booking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#booking-form", booking: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.booking_show_path(conn, :show, booking))

      assert html =~ "Booking updated successfully"
      assert html =~ "some updated location"
    end
  end
end

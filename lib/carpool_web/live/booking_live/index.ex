defmodule CarpoolWeb.BookingLive.Index do
  use CarpoolWeb, :live_view

  alias Carpool.Bookings
  alias Carpool.Bookings.Booking
  alias Carpool.Accounts

  @impl true
  def mount(_params, session, socket) do
    user= Accounts.get_user_by_session_token(session["user_token"])

{:ok, socket
|>assign(:bookings, list_bookings())
|>assign(:user, user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Booking")
    |> assign(:booking, Bookings.get_booking!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Booking")
    |> assign(:booking, %Booking{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bookings")
    |> assign(:booking, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    booking = Bookings.get_booking!(id)
    {:ok, _} = Bookings.delete_booking(booking)

    {:noreply, assign(socket, :bookings, list_bookings())}
  end

  defp list_bookings do
    Bookings.list_bookings()
  end
end

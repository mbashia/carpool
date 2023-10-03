defmodule CarpoolWeb.TripLive.Show do
  use CarpoolWeb, :live_view

  alias Carpool.Trips
  alias Carpool.Bookings
  alias Carpool.Bookings.Booking
  alias Carpool.Accounts
  alias Carpool.Messages
  alias Carpool.Messages.Message

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    users = Accounts.list_users()

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:users, users)}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:booking, %Booking{})
     |> assign(:trip, Trips.get_trip!(params["id"]))
     |> assign(:bookings, Bookings.get_booking_by_trip_id(params["id"]))
     |> assign(:receiver_id, params["user_id"])
     |> assign(:chat_changeset, Messages.change_message(%Message{}))}
  end

  defp page_title(:show), do: "Show Trip"
  defp page_title(:edit), do: "Edit Trip"
  defp page_title(:addbooking), do: "Add Booking"
  defp page_title(:chat), do: "chat"
end

defmodule CarpoolWeb.TripLive.Show do
  use CarpoolWeb, :live_view

  alias Carpool.Trips
  alias Carpool.Bookings
  alias Carpool.Bookings.Booking
  alias Carpool.Accounts

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:user, user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:booking, %Booking{})
     |> assign(:trip, Trips.get_trip!(id))}
  end

  defp page_title(:show), do: "Show Trip"
  defp page_title(:edit), do: "Edit Trip"
  defp page_title(:addbooking), do: "Add Booking"
end

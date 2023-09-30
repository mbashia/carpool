defmodule CarpoolWeb.BookingLive.Show do
  use CarpoolWeb, :live_view

  alias Carpool.Bookings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:booking, Bookings.get_booking!(id))}
  end

  defp page_title(:show), do: "Show Booking"
  defp page_title(:edit), do: "Edit Booking"
end

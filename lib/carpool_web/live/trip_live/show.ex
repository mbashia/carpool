defmodule CarpoolWeb.TripLive.Show do
  use CarpoolWeb, :live_view

  alias Carpool.Trips

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:trip, Trips.get_trip!(id))}
  end

  defp page_title(:show), do: "Show Trip"
  defp page_title(:edit), do: "Edit Trip"
end

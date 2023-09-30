defmodule CarpoolWeb.TripLive.Index do
  use CarpoolWeb, :dashboard_live_view

  alias Carpool.Trips
  alias Carpool.Trips.Trip
  alias Carpool.Accounts

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:trips, list_trips())
     |> assign(:user, user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Trip")
    |> assign(:trip, Trips.get_trip!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Trip")
    |> assign(:trip, %Trip{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Trips")
    |> assign(:trip, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    trip = Trips.get_trip!(id)
    {:ok, _} = Trips.delete_trip(trip)

    {:noreply, assign(socket, :trips, list_trips())}
  end

  defp list_trips do
    Trips.list_trips()
  end
end

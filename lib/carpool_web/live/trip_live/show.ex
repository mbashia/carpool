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
    chats =
      if params["user_id"] do
        Messages.list_messages_for_a_receiver_and_sender(
          socket.assigns.user.id,
          params["user_id"]
        )
      else
        ""
      end

    #  chats = Messages.list_messages_for_a_receiver_and_sender(socket.assigns.user.id,params["user_id"])
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:booking, %Booking{})
     |> assign(:trip, Trips.get_trip!(params["id"]))
     |> assign(:bookings, Bookings.get_booking_by_trip_id(params["id"]))
     |> assign(:receiver_id, params["user_id"])
     |> assign(:chat_changeset, Messages.change_message(%Message{}))
     |> assign(:chats, chats)}
  end

  def handle_event("save", %{"message" => %{"text" => message}}, socket) do
    receiver_id = String.to_integer(socket.assigns.receiver_id)
    chat_changeset = Messages.change_message(%Message{})

    message_params = %{
      "text" => message,
      "sender_id" => socket.assigns.user.id,
      "receiver_id" => receiver_id
    }

    IO.inspect(chat_changeset)

    case Messages.create_message(message_params) do
      {:ok, _message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
         |> assign(:chat_changeset, chat_changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp page_title(:show), do: "Show Trip"
  defp page_title(:edit), do: "Edit Trip"
  defp page_title(:addbooking), do: "Add Booking"
  defp page_title(:chat), do: "chat"
end

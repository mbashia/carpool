defmodule CarpoolWeb.BookingLive.FormComponent do
  alias Phoenix.LiveViewTest.DOM
  use CarpoolWeb, :live_component

  alias Carpool.Bookings
  alias Carpool.Mpesas
  alias Carpool.Accounts

  @impl true
  def update(%{booking: booking} = assigns, socket) do
    changeset = Bookings.change_booking(booking)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:n, false)
     |> assign(:success_modal, false)
     |> assign(:error_message, "")
     |> assign(:distance, 0.0)
     |> assign(:fare, 0.0)
     |> assign(:error_modal, false)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"booking" => booking_params}, socket) do
    changeset =
      socket.assigns.booking
      |> Bookings.change_booking(booking_params)
      |> Map.put(:action, :validate)

    distance =
      if booking_params["booking_latitude_to"] != "" &&
           booking_params["booking_longitude_to"] != "" &&
           booking_params["booking_latitude_from"] != "" &&
           booking_params["booking_longitude_from"] != "" do
        Geocalc.distance_between(
          [
            String.to_float(booking_params["booking_longitude_to"]),
            String.to_float(booking_params["booking_latitude_to"])
          ],
          [
            String.to_float(booking_params["booking_longitude_from"]),
            String.to_float(booking_params["booking_latitude_from"])
          ]
        )
      else
        0
      end

    distance =
      (distance / 1000)
      |> Float.round(2)

    fare =
      if distance != 0.0 do
        kilometers_per_litre = socket.assigns.trip.kilometres_per_litre |> String.to_integer()
        price_of_fuel = 211
        distance / kilometers_per_litre * price_of_fuel
      else
        0
      end

    {:noreply,
     socket
     |> assign(:distance, distance)
     |> assign(:fare, fare)
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"booking" => booking_params}, socket) do
    save_booking(socket, socket.assigns.action, booking_params)
  end

  defp save_booking(socket, :edit, booking_params) do
    case Bookings.update_booking(socket.assigns.booking, booking_params) do
      {:ok, _booking} ->
        {:noreply,
         socket
         |> put_flash(:info, "Booking updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_booking(socket, :addbooking, booking_params) do
    new_params =
      booking_params
      |> Map.put("user_id", socket.assigns.user.id)

    IO.inspect(new_params)
    IO.inspect(socket.assigns.changeset)

    case Bookings.create_booking(new_params) do
      {:ok, _booking} ->
        {:noreply,
         socket
         |> put_flash(:info, "Booking created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("pay", params, socket) do
    case Mpesas.make_request(
           1,
           params["booking"]["phone_number"],
           "reference",
           "description"
         ) do
      {:error, %HTTPoison.Error{reason: :timeout, id: nil}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Session timed out")}

      {:error, error} ->
        {:noreply,
         socket
         |> put_flash(:info, "An error occured #{error}")}

      {:ok, mpesa} ->
        {:noreply,
         socket
         |> assign(:checkoutId, mpesa["CheckoutRequestID"])
         |> assign(:booking_latitude_to, params["booking"]["booking_latitude_to"])
         |> assign(:booking_longitude_to, params["booking"]["booking_longitude_to"])
         |> assign(:booking_latitude_from, params["booking"]["booking_latitude_from"])
         |> assign(:booking_longitude_from, params["booking"]["booking_longitude_from"])
         |> assign(:location_from, params["booking"]["location_from"])
         |> assign(:location_to, params["booking"]["location_to"])
         |> assign(:trip_id, params["booking"]["trip_id"])
         |> assign(:phone_number, params["booking"]["phone_number"])
         |> assign(:notes, params["booking"]["notes"])
         |> assign(:subscription, params["booking"]["subscription"])
         |> factorial(socket.assigns.n, "Initiated", params)}

      _ ->
        {:noreply, socket}
    end
  end

  def factorial(socket, n, string, params) when n == false do
    case IO.inspect(Mpesas.make_query(socket.assigns.checkoutId)) do
      {:ok, mpesa} ->
        case mpesa["ResultCode"] do
          "0" ->
            factorial(socket, true, "Paid", params)

          "1" ->
            socket
            |> factorial("error", "Balance is insufficient", params)

          "17" ->
            socket
            |> factorial("error", "Check if you entered details correctly", params)

          "26" ->
            socket
            |> factorial("error", "System busy, Try again in a short while", params)

          "2001" ->
            socket
            |> factorial("error", "Wrong Pin entered", params)

          "1001" ->
            socket
            |> factorial("error", "Unable to lock subscriber", params)

          "1019" ->
            socket
            |> factorial("error", "Transaction expired. No MO has been received", params)

          "9999" ->
            socket
            |> factorial("error", "Request cancelled by user", params)

          "1032" ->
            factorial(socket, "error", "Request cancelled by user", params)

          "1036" ->
            socket
            |> factorial("error", "SMSC ACK timeout", params)

          "1037" ->
            socket
            |> factorial("error", "Payment timeout", params)

          "SFC_IC0003" ->
            socket
            |> factorial("error", "Payment timeout", params)

          _ ->
            socket
            |> put_flash("error", "Error processing payment")
        end

      {:error, params} ->
        factorial(socket, false, "Payment has started", params)
    end
  end

  def factorial(socket, n, string, params) when n == true do
    new_params = %{
      "booking_latitude_from" => socket.assigns.booking_latitude_from,
      "booking_latitude_to" => socket.assigns.booking_latitude_to,
      "booking_longitude_from" => socket.assigns.booking_longitude_from,
      "booking_longitude_to" => socket.assigns.booking_longitude_to,
      "location_from" => socket.assigns.location_from,
      "location_to" => socket.assigns.location_to,
      "notes" => socket.assigns.notes,
      "phone_number" => socket.assigns.phone_number,
      "trip_id" => socket.assigns.trip_id,
      "user_id" => socket.assigns.user.id,
      "subscription" => socket.assigns.subscription
    }

    driver = Accounts.get_user!(socket.assigns.trip.user_id)
    rider = Accounts.get_user!(socket.assigns.user.id)

    # sms_url = "https://api.tiaraconnect.io/api/messaging/sendsms"

    # sms_headers = [
    #   {
    #     "Content-Type",
    #     "application/json"
    #   },
    #   {
    #     "Authorization",
    #     "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyOTAiLCJvaWQiOjI5MCwidWlkIjoiYWUzMGRjZTItMjIzYi00ODUzLWJmMDItNDE5ZWI2MzMzY2Y5IiwiYXBpZCI6MTgzLCJpYXQiOjE2OTM1OTAzNDksImV4cCI6MjAzMzU5MDM0OX0.mG9d0tTkmx49OQKMKQFYKnIQMHFQEIckHBnGe5jTjg3fU95aHLxrtouqsPGr7Yi3GKFt674_ImiLtJavAa4OIw"
    #   }
    # ]

    # sms_body =
    #   %{
    #     "from" => "TIARACONECT",
    #     "to" => socket.assigns.phone_number,
    #     "message" =>
    #       "Hello #{rider.firstname} ,Thanks for making a booking , #{driver.firstname} will be leaving at #{socket.assigns.trip.departure_time} and coming back at #{socket.assigns.trip.return_time} , Your pick up point is #{socket.assigns.location_from} and you will be dropped off at #{socket.assigns.location_to} . Thank you for choosing Kilipool .",
    #     "refId" => "09wiwu088e"
    #   }
    #   |> Poison.encode!()

    # IO.inspect(HTTPoison.post(sms_url, sms_body, sms_headers))

    case Bookings.create_booking(new_params) do
      {:ok, _booking} ->
        socket
        |> put_flash(:info, "Succesfully Paid , This Booking is now confirmed")
        |> push_redirect(to: socket.assigns.return_to)

      {:error, %Ecto.Changeset{} = changeset} ->
        socket
        |> put_flash(:info, "Payment Unsuccessful, #{string}")
        |> push_redirect(to: socket.assigns.return_to)
    end
  end

  def factorial(socket, n, string, params) when n == "error" do
    socket
    |> put_flash(:info, "Payment Unsuccessful, #{string}")
    |> push_redirect(to: socket.assigns.return_to)
  end
end

defmodule CarpoolWeb.BookingLive.FormComponent do
  use CarpoolWeb, :live_component

  alias Carpool.Bookings
  alias Carpool.Mpesas

  @impl true
  def update(%{booking: booking} = assigns, socket) do
    changeset = Bookings.change_booking(booking)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:n, false)
     |> assign(:success_modal, false)
     |> assign(:error_message, "")
     |> assign(:error_modal, false)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"booking" => booking_params}, socket) do
    changeset =
      socket.assigns.booking
      |> Bookings.change_booking(booking_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
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
           "254740769596",
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
            |> put_flash("error", "Error processing payment ")
        end

      {:error, params} ->
        factorial(socket, false, "Payment has started", params)
    end
  end

  def factorial(socket, n, string, params) when n == true do
    IO.inspect(params)

    socket
    |> put_flash(:warning, "Payment Unsuccessful, #{string}")
    |> push_redirect(to: socket.assigns.return_to)
    # new_params =
    #   params
    #   |> Map.put("user_id", socket.assigns.user.id)

    # IO.inspect(new_params)
    # IO.inspect(socket.assigns.changeset)

    # case Bookings.create_booking(new_params) do
    #   {:ok, _booking} ->
    #     socket
    #     |> put_flash(:info, "Succesfully Paid , your booking has been confirmed")
    #     |> push_redirect(to: socket.assigns.return_to)

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     socket
    #     |> assign(:changeset, changeset)
    #     |> put_flash(:info, "Payment Unsuccessful, #{string}")
    # end
  end

  def factorial(socket, n, string, params) when n == "error" do
    IO.inspect(params)

  end
end

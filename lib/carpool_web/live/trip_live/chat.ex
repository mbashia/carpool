defmodule CarpoolWeb.TripLive.ChatComponent do
  use CarpoolWeb, :live_component
  alias Carpool.Messages

  def render(assigns) do
    ~H"""
    <div class=" w-[200px] h-[200px]">
      this is where you will chat from
      <.form let={f} for={@chat_changeset} id="message-form" phx-submit="save" phx-target={@myself}>
        <%= label(f, :text) %>
        <%= text_input(f, :text) %>
        <%= error_tag(f, :text) %>

        <div>
          <%= submit("send", phx_disable_with: "Saving...") %>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("save", %{"message" => %{"text" => message}}, socket) do
    IO.inspect(message)
    receiver_id = String.to_integer(socket.assigns.receiver_id)

    message_params = %{
      "text" => message,
      "sender_id" => socket.assigns.user.id,
      "receiver_id" => receiver_id
    }

    case Messages.create_message(message_params) do
      {:ok, _message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

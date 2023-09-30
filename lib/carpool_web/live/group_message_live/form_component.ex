defmodule CarpoolWeb.Group_messageLive.FormComponent do
  use CarpoolWeb, :live_component

  alias Carpool.Group_messages

  @impl true
  def update(%{group_message: group_message} = assigns, socket) do
    changeset = Group_messages.change_group_message(group_message)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"group_message" => group_message_params}, socket) do
    changeset =
      socket.assigns.group_message
      |> Group_messages.change_group_message(group_message_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"group_message" => group_message_params}, socket) do
    save_group_message(socket, socket.assigns.action, group_message_params)
  end

  defp save_group_message(socket, :edit, group_message_params) do
    case Group_messages.update_group_message(socket.assigns.group_message, group_message_params) do
      {:ok, _group_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Group message updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_group_message(socket, :new, group_message_params) do
    case Group_messages.create_group_message(group_message_params) do
      {:ok, _group_message} ->
        {:noreply,
         socket
         |> put_flash(:info, "Group message created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

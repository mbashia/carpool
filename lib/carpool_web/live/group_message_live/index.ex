defmodule CarpoolWeb.Group_messageLive.Index do
  use CarpoolWeb, :live_view

  alias Carpool.Group_messages
  alias Carpool.Group_messages.Group_message

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :group_messages, list_group_messages())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Group message")
    |> assign(:group_message, Group_messages.get_group_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group message")
    |> assign(:group_message, %Group_message{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Group messages")
    |> assign(:group_message, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    group_message = Group_messages.get_group_message!(id)
    {:ok, _} = Group_messages.delete_group_message(group_message)

    {:noreply, assign(socket, :group_messages, list_group_messages())}
  end

  defp list_group_messages do
    Group_messages.list_group_messages()
  end
end

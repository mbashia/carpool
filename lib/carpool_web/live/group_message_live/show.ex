defmodule CarpoolWeb.Group_messageLive.Show do
  use CarpoolWeb, :live_view

  alias Carpool.Group_messages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:group_message, Group_messages.get_group_message!(id))}
  end

  defp page_title(:show), do: "Show Group message"
  defp page_title(:edit), do: "Edit Group message"
end

defmodule CarpoolWeb.Group_memberLive.Index do
  use CarpoolWeb, :live_view

  alias Carpool.Group_members
  alias Carpool.Group_members.Group_member

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :group_members, list_group_members())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Group member")
    |> assign(:group_member, Group_members.get_group_member!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Group member")
    |> assign(:group_member, %Group_member{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Group members")
    |> assign(:group_member, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    group_member = Group_members.get_group_member!(id)
    {:ok, _} = Group_members.delete_group_member(group_member)

    {:noreply, assign(socket, :group_members, list_group_members())}
  end

  defp list_group_members do
    Group_members.list_group_members()
  end
end

defmodule CarpoolWeb.Group_memberLive.FormComponent do
  use CarpoolWeb, :live_component

  alias Carpool.Group_members

  @impl true
  def update(%{group_member: group_member} = assigns, socket) do
    changeset = Group_members.change_group_member(group_member)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"group_member" => group_member_params}, socket) do
    changeset =
      socket.assigns.group_member
      |> Group_members.change_group_member(group_member_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"group_member" => group_member_params}, socket) do
    save_group_member(socket, socket.assigns.action, group_member_params)
  end

  defp save_group_member(socket, :edit, group_member_params) do
    case Group_members.update_group_member(socket.assigns.group_member, group_member_params) do
      {:ok, _group_member} ->
        {:noreply,
         socket
         |> put_flash(:info, "Group member updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_group_member(socket, :new, group_member_params) do
    case Group_members.create_group_member(group_member_params) do
      {:ok, _group_member} ->
        {:noreply,
         socket
         |> put_flash(:info, "Group member created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

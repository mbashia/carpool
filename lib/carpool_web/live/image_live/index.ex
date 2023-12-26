defmodule CarpoolWeb.ImageLive.Index do
  use CarpoolWeb, :live_view

  alias Carpool.Images
  alias Carpool.Images.Image

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :image_collection, list_image())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Image")
    |> assign(:image, Images.get_image!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Image")
    |> assign(:image, %Image{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Image")
    |> assign(:image, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    image = Images.get_image!(id)
    {:ok, _} = Images.delete_image(image)

    {:noreply, assign(socket, :image_collection, list_image())}
  end

  defp list_image do
    Images.list_image()
  end
end

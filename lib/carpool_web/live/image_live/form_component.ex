defmodule CarpoolWeb.ImageLive.FormComponent do
  use CarpoolWeb, :live_component

  alias Carpool.Images

  @impl true
  def update(%{image: image} = assigns, socket) do
    changeset = Images.change_image(image)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:uploaded_files, [])
     |> allow_upload(:image, accept: ~w(.jpg .png .jpeg), max_entries: 1)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"image" => image_params}, socket) do
    changeset =
      socket.assigns.image
      |> Images.change_image(image_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"image" => image_params}, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:carpool), "static", "uploads", Path.basename(path)])

        # The `static/uploads` directory must exist for `File.cp!/2`
        # and MyAppWeb.static_paths/0 should contain uploads to work,.
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(dest)}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}

    new_image_params = Map.put(image_params, "image_url", List.first(uploaded_files))

    save_image(socket, socket.assigns.action, new_image_params)
  end

  defp save_image(socket, :edit, image_params) do
    case Images.update_image(socket.assigns.image, image_params) do
      {:ok, _image} ->
        {:noreply,
         socket
         |> put_flash(:info, "Image updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_image(socket, :new, image_params) do
    case Images.create_image(image_params) do
      {:ok, _image} ->
        {:noreply,
         socket
         |> put_flash(:info, "Image created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

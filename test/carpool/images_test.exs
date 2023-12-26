defmodule Carpool.ImagesTest do
  use Carpool.DataCase

  alias Carpool.Images

  describe "image" do
    alias Carpool.Images.Image

    import Carpool.ImagesFixtures

    @invalid_attrs %{image_url: nil}

    test "list_image/0 returns all image" do
      image = image_fixture()
      assert Images.list_image() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{image_url: "some image_url"}

      assert {:ok, %Image{} = image} = Images.create_image(valid_attrs)
      assert image.image_url == "some image_url"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{image_url: "some updated image_url"}

      assert {:ok, %Image{} = image} = Images.update_image(image, update_attrs)
      assert image.image_url == "some updated image_url"
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_image(image, @invalid_attrs)
      assert image == Images.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Images.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Images.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Images.change_image(image)
    end
  end
end

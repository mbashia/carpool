defmodule Carpool.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Carpool.Images` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        image_url: "some image_url"
      })
      |> Carpool.Images.create_image()

    image
  end
end

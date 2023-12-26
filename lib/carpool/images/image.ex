defmodule Carpool.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "image" do
    field :image_url, :string

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:image_url])
    |> validate_required([:image_url])
  end
end

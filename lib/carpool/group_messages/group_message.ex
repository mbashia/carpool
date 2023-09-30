defmodule Carpool.Group_messages.Group_message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "group_messages" do
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(group_message, attrs) do
    group_message
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end

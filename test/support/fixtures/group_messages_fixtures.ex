defmodule Carpool.Group_messagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Carpool.Group_messages` context.
  """

  @doc """
  Generate a group_message.
  """
  def group_message_fixture(attrs \\ %{}) do
    {:ok, group_message} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> Carpool.Group_messages.create_group_message()

    group_message
  end
end

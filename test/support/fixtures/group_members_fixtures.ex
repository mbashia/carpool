defmodule Carpool.Group_membersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Carpool.Group_members` context.
  """

  @doc """
  Generate a group_member.
  """
  def group_member_fixture(attrs \\ %{}) do
    {:ok, group_member} =
      attrs
      |> Enum.into(%{
        group_id: "some group_id",
        user_id: "some user_id"
      })
      |> Carpool.Group_members.create_group_member()

    group_member
  end
end

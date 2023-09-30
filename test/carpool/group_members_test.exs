defmodule Carpool.Group_membersTest do
  use Carpool.DataCase

  alias Carpool.Group_members

  describe "group_members" do
    alias Carpool.Group_members.Group_member

    import Carpool.Group_membersFixtures

    @invalid_attrs %{group_id: nil, user_id: nil}

    test "list_group_members/0 returns all group_members" do
      group_member = group_member_fixture()
      assert Group_members.list_group_members() == [group_member]
    end

    test "get_group_member!/1 returns the group_member with given id" do
      group_member = group_member_fixture()
      assert Group_members.get_group_member!(group_member.id) == group_member
    end

    test "create_group_member/1 with valid data creates a group_member" do
      valid_attrs = %{group_id: "some group_id", user_id: "some user_id"}

      assert {:ok, %Group_member{} = group_member} = Group_members.create_group_member(valid_attrs)
      assert group_member.group_id == "some group_id"
      assert group_member.user_id == "some user_id"
    end

    test "create_group_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Group_members.create_group_member(@invalid_attrs)
    end

    test "update_group_member/2 with valid data updates the group_member" do
      group_member = group_member_fixture()
      update_attrs = %{group_id: "some updated group_id", user_id: "some updated user_id"}

      assert {:ok, %Group_member{} = group_member} = Group_members.update_group_member(group_member, update_attrs)
      assert group_member.group_id == "some updated group_id"
      assert group_member.user_id == "some updated user_id"
    end

    test "update_group_member/2 with invalid data returns error changeset" do
      group_member = group_member_fixture()
      assert {:error, %Ecto.Changeset{}} = Group_members.update_group_member(group_member, @invalid_attrs)
      assert group_member == Group_members.get_group_member!(group_member.id)
    end

    test "delete_group_member/1 deletes the group_member" do
      group_member = group_member_fixture()
      assert {:ok, %Group_member{}} = Group_members.delete_group_member(group_member)
      assert_raise Ecto.NoResultsError, fn -> Group_members.get_group_member!(group_member.id) end
    end

    test "change_group_member/1 returns a group_member changeset" do
      group_member = group_member_fixture()
      assert %Ecto.Changeset{} = Group_members.change_group_member(group_member)
    end
  end
end

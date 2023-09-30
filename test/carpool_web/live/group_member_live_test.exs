defmodule CarpoolWeb.Group_memberLiveTest do
  use CarpoolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Carpool.Group_membersFixtures

  @create_attrs %{group_id: "some group_id", user_id: "some user_id"}
  @update_attrs %{group_id: "some updated group_id", user_id: "some updated user_id"}
  @invalid_attrs %{group_id: nil, user_id: nil}

  defp create_group_member(_) do
    group_member = group_member_fixture()
    %{group_member: group_member}
  end

  describe "Index" do
    setup [:create_group_member]

    test "lists all group_members", %{conn: conn, group_member: group_member} do
      {:ok, _index_live, html} = live(conn, Routes.group_member_index_path(conn, :index))

      assert html =~ "Listing Group members"
      assert html =~ group_member.group_id
    end

    test "saves new group_member", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.group_member_index_path(conn, :index))

      assert index_live |> element("a", "New Group member") |> render_click() =~
               "New Group member"

      assert_patch(index_live, Routes.group_member_index_path(conn, :new))

      assert index_live
             |> form("#group_member-form", group_member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#group_member-form", group_member: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.group_member_index_path(conn, :index))

      assert html =~ "Group member created successfully"
      assert html =~ "some group_id"
    end

    test "updates group_member in listing", %{conn: conn, group_member: group_member} do
      {:ok, index_live, _html} = live(conn, Routes.group_member_index_path(conn, :index))

      assert index_live |> element("#group_member-#{group_member.id} a", "Edit") |> render_click() =~
               "Edit Group member"

      assert_patch(index_live, Routes.group_member_index_path(conn, :edit, group_member))

      assert index_live
             |> form("#group_member-form", group_member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#group_member-form", group_member: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.group_member_index_path(conn, :index))

      assert html =~ "Group member updated successfully"
      assert html =~ "some updated group_id"
    end

    test "deletes group_member in listing", %{conn: conn, group_member: group_member} do
      {:ok, index_live, _html} = live(conn, Routes.group_member_index_path(conn, :index))

      assert index_live
             |> element("#group_member-#{group_member.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#group_member-#{group_member.id}")
    end
  end

  describe "Show" do
    setup [:create_group_member]

    test "displays group_member", %{conn: conn, group_member: group_member} do
      {:ok, _show_live, html} =
        live(conn, Routes.group_member_show_path(conn, :show, group_member))

      assert html =~ "Show Group member"
      assert html =~ group_member.group_id
    end

    test "updates group_member within modal", %{conn: conn, group_member: group_member} do
      {:ok, show_live, _html} =
        live(conn, Routes.group_member_show_path(conn, :show, group_member))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Group member"

      assert_patch(show_live, Routes.group_member_show_path(conn, :edit, group_member))

      assert show_live
             |> form("#group_member-form", group_member: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#group_member-form", group_member: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.group_member_show_path(conn, :show, group_member))

      assert html =~ "Group member updated successfully"
      assert html =~ "some updated group_id"
    end
  end
end

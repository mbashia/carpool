defmodule CarpoolWeb.Group_messageLiveTest do
  use CarpoolWeb.ConnCase

  import Phoenix.LiveViewTest
  import Carpool.Group_messagesFixtures

  @create_attrs %{text: "some text"}
  @update_attrs %{text: "some updated text"}
  @invalid_attrs %{text: nil}

  defp create_group_message(_) do
    group_message = group_message_fixture()
    %{group_message: group_message}
  end

  describe "Index" do
    setup [:create_group_message]

    test "lists all group_messages", %{conn: conn, group_message: group_message} do
      {:ok, _index_live, html} = live(conn, Routes.group_message_index_path(conn, :index))

      assert html =~ "Listing Group messages"
      assert html =~ group_message.text
    end

    test "saves new group_message", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.group_message_index_path(conn, :index))

      assert index_live |> element("a", "New Group message") |> render_click() =~
               "New Group message"

      assert_patch(index_live, Routes.group_message_index_path(conn, :new))

      assert index_live
             |> form("#group_message-form", group_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#group_message-form", group_message: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.group_message_index_path(conn, :index))

      assert html =~ "Group message created successfully"
      assert html =~ "some text"
    end

    test "updates group_message in listing", %{conn: conn, group_message: group_message} do
      {:ok, index_live, _html} = live(conn, Routes.group_message_index_path(conn, :index))

      assert index_live |> element("#group_message-#{group_message.id} a", "Edit") |> render_click() =~
               "Edit Group message"

      assert_patch(index_live, Routes.group_message_index_path(conn, :edit, group_message))

      assert index_live
             |> form("#group_message-form", group_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#group_message-form", group_message: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.group_message_index_path(conn, :index))

      assert html =~ "Group message updated successfully"
      assert html =~ "some updated text"
    end

    test "deletes group_message in listing", %{conn: conn, group_message: group_message} do
      {:ok, index_live, _html} = live(conn, Routes.group_message_index_path(conn, :index))

      assert index_live |> element("#group_message-#{group_message.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#group_message-#{group_message.id}")
    end
  end

  describe "Show" do
    setup [:create_group_message]

    test "displays group_message", %{conn: conn, group_message: group_message} do
      {:ok, _show_live, html} = live(conn, Routes.group_message_show_path(conn, :show, group_message))

      assert html =~ "Show Group message"
      assert html =~ group_message.text
    end

    test "updates group_message within modal", %{conn: conn, group_message: group_message} do
      {:ok, show_live, _html} = live(conn, Routes.group_message_show_path(conn, :show, group_message))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Group message"

      assert_patch(show_live, Routes.group_message_show_path(conn, :edit, group_message))

      assert show_live
             |> form("#group_message-form", group_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#group_message-form", group_message: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.group_message_show_path(conn, :show, group_message))

      assert html =~ "Group message updated successfully"
      assert html =~ "some updated text"
    end
  end
end

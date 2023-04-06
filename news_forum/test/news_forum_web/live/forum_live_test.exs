defmodule NewsForumWeb.ForumLiveTest do
  use NewsForumWeb.ConnCase

  import Phoenix.LiveViewTest
  import NewsForum.ForumsFixtures

  @create_attrs %{articles: [], category: "some category", desc: "some desc", members: [], title: "some title"}
  @update_attrs %{articles: [], category: "some updated category", desc: "some updated desc", members: [], title: "some updated title"}
  @invalid_attrs %{articles: [], category: nil, desc: nil, members: [], title: nil}

  defp create_forum(_) do
    forum = forum_fixture()
    %{forum: forum}
  end

  describe "Index" do
    setup [:create_forum]

    test "lists all forums", %{conn: conn, forum: forum} do
      {:ok, _index_live, html} = live(conn, ~p"/forums")

      assert html =~ "Listing Forums"
      assert html =~ forum.category
    end

    test "saves new forum", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/forums")

      assert index_live |> element("a", "New Forum") |> render_click() =~
               "New Forum"

      assert_patch(index_live, ~p"/forums/new")

      assert index_live
             |> form("#forum-form", forum: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#forum-form", forum: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/forums")

      html = render(index_live)
      assert html =~ "Forum created successfully"
      assert html =~ "some category"
    end

    test "updates forum in listing", %{conn: conn, forum: forum} do
      {:ok, index_live, _html} = live(conn, ~p"/forums")

      assert index_live |> element("#forums-#{forum.id} a", "Edit") |> render_click() =~
               "Edit Forum"

      assert_patch(index_live, ~p"/forums/#{forum}/edit")

      assert index_live
             |> form("#forum-form", forum: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#forum-form", forum: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/forums")

      html = render(index_live)
      assert html =~ "Forum updated successfully"
      assert html =~ "some updated category"
    end

    test "deletes forum in listing", %{conn: conn, forum: forum} do
      {:ok, index_live, _html} = live(conn, ~p"/forums")

      assert index_live |> element("#forums-#{forum.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#forums-#{forum.id}")
    end
  end

  describe "Show" do
    setup [:create_forum]

    test "displays forum", %{conn: conn, forum: forum} do
      {:ok, _show_live, html} = live(conn, ~p"/forums/#{forum}")

      assert html =~ "Show Forum"
      assert html =~ forum.category
    end

    test "updates forum within modal", %{conn: conn, forum: forum} do
      {:ok, show_live, _html} = live(conn, ~p"/forums/#{forum}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Forum"

      assert_patch(show_live, ~p"/forums/#{forum}/show/edit")

      assert show_live
             |> form("#forum-form", forum: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#forum-form", forum: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/forums/#{forum}")

      html = render(show_live)
      assert html =~ "Forum updated successfully"
      assert html =~ "some updated category"
    end
  end
end

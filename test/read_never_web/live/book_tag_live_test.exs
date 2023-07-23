defmodule ReadNeverWeb.BookTagLiveTest do
  use ReadNeverWeb.ConnCase

  import Phoenix.LiveViewTest
  import ReadNever.BookShelfFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_book_tag(_) do
    book_tag = book_tag_fixture()
    %{book_tag: book_tag}
  end

  describe "Index" do
    setup [:create_book_tag]

    test "lists all book_tags", %{conn: conn, book_tag: book_tag} do
      {:ok, _index_live, html} = live(conn, ~p"/book_tags")

      assert html =~ "Listing Book tags"
      assert html =~ book_tag.name
    end

    test "saves new book_tag", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/book_tags")

      assert index_live |> element("a", "New Book tag") |> render_click() =~
               "New Book tag"

      assert_patch(index_live, ~p"/book_tags/new")

      assert index_live
             |> form("#book_tag-form", book_tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#book_tag-form", book_tag: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/book_tags")

      html = render(index_live)
      assert html =~ "Book tag created successfully"
      assert html =~ "some name"
    end

    test "updates book_tag in listing", %{conn: conn, book_tag: book_tag} do
      {:ok, index_live, _html} = live(conn, ~p"/book_tags")

      assert index_live |> element("#book_tags-#{book_tag.id} a", "Edit") |> render_click() =~
               "Edit Book tag"

      assert_patch(index_live, ~p"/book_tags/#{book_tag}/edit")

      assert index_live
             |> form("#book_tag-form", book_tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#book_tag-form", book_tag: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/book_tags")

      html = render(index_live)
      assert html =~ "Book tag updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes book_tag in listing", %{conn: conn, book_tag: book_tag} do
      {:ok, index_live, _html} = live(conn, ~p"/book_tags")

      assert index_live |> element("#book_tags-#{book_tag.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#book_tags-#{book_tag.id}")
    end
  end

  describe "Show" do
    setup [:create_book_tag]

    test "displays book_tag", %{conn: conn, book_tag: book_tag} do
      {:ok, _show_live, html} = live(conn, ~p"/book_tags/#{book_tag}")

      assert html =~ "Show Book tag"
      assert html =~ book_tag.name
    end

    test "updates book_tag within modal", %{conn: conn, book_tag: book_tag} do
      {:ok, show_live, _html} = live(conn, ~p"/book_tags/#{book_tag}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Book tag"

      assert_patch(show_live, ~p"/book_tags/#{book_tag}/show/edit")

      assert show_live
             |> form("#book_tag-form", book_tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#book_tag-form", book_tag: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/book_tags/#{book_tag}")

      html = render(show_live)
      assert html =~ "Book tag updated successfully"
      assert html =~ "some updated name"
    end
  end
end

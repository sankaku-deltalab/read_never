defmodule ReadNeverWeb.BooksDirectoryLiveTest do
  use ReadNeverWeb.ConnCase

  import Phoenix.LiveViewTest
  import ReadNever.BookShelfFixtures

  @create_attrs %{name: "some name", directory_path: "some directory_path"}
  @update_attrs %{name: "some updated name", directory_path: "some updated directory_path"}
  @invalid_attrs %{name: nil, directory_path: nil}

  defp create_books_directory(_) do
    books_directory = books_directory_fixture()
    %{books_directory: books_directory}
  end

  describe "Index" do
    setup [:create_books_directory]

    test "lists all books_directories", %{conn: conn, books_directory: books_directory} do
      {:ok, _index_live, html} = live(conn, ~p"/books_directories")

      assert html =~ "Listing Books directories"
      assert html =~ books_directory.name
    end

    test "saves new books_directory", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/books_directories")

      assert index_live |> element("a", "New Books directory") |> render_click() =~
               "New Books directory"

      assert_patch(index_live, ~p"/books_directories/new")

      assert index_live
             |> form("#books_directory-form", books_directory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#books_directory-form", books_directory: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/books_directories")

      html = render(index_live)
      assert html =~ "Books directory created successfully"
      assert html =~ "some name"
    end

    test "updates books_directory in listing", %{conn: conn, books_directory: books_directory} do
      {:ok, index_live, _html} = live(conn, ~p"/books_directories")

      assert index_live |> element("#books_directories-#{books_directory.id} a", "Edit") |> render_click() =~
               "Edit Books directory"

      assert_patch(index_live, ~p"/books_directories/#{books_directory}/edit")

      assert index_live
             |> form("#books_directory-form", books_directory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#books_directory-form", books_directory: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/books_directories")

      html = render(index_live)
      assert html =~ "Books directory updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes books_directory in listing", %{conn: conn, books_directory: books_directory} do
      {:ok, index_live, _html} = live(conn, ~p"/books_directories")

      assert index_live |> element("#books_directories-#{books_directory.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#books_directories-#{books_directory.id}")
    end
  end

  describe "Show" do
    setup [:create_books_directory]

    test "displays books_directory", %{conn: conn, books_directory: books_directory} do
      {:ok, _show_live, html} = live(conn, ~p"/books_directories/#{books_directory}")

      assert html =~ "Show Books directory"
      assert html =~ books_directory.name
    end

    test "updates books_directory within modal", %{conn: conn, books_directory: books_directory} do
      {:ok, show_live, _html} = live(conn, ~p"/books_directories/#{books_directory}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Books directory"

      assert_patch(show_live, ~p"/books_directories/#{books_directory}/show/edit")

      assert show_live
             |> form("#books_directory-form", books_directory: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#books_directory-form", books_directory: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/books_directories/#{books_directory}")

      html = render(show_live)
      assert html =~ "Books directory updated successfully"
      assert html =~ "some updated name"
    end
  end
end

defmodule ReadNeverWeb.BookPriorityChangeLogLiveTest do
  use ReadNeverWeb.ConnCase

  import Phoenix.LiveViewTest
  import ReadNever.BookShelfFixtures

  @create_attrs %{priority: :new, change_datetime: "2023-07-22T08:34:00Z"}
  @update_attrs %{priority: :reading, change_datetime: "2023-07-23T08:34:00Z"}
  @invalid_attrs %{priority: nil, change_datetime: nil}

  defp create_book_priority_change_log(_) do
    book_priority_change_log = book_priority_change_log_fixture()
    %{book_priority_change_log: book_priority_change_log}
  end

  describe "Index" do
    setup [:create_book_priority_change_log]

    test "lists all book_priority_changelog", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/book_priority_changelog")

      assert html =~ "Listing Book priority changelog"
    end

    test "saves new book_priority_change_log", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/book_priority_changelog")

      assert index_live |> element("a", "New Book priority change log") |> render_click() =~
               "New Book priority change log"

      assert_patch(index_live, ~p"/book_priority_changelog/new")

      assert index_live
             |> form("#book_priority_change_log-form", book_priority_change_log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#book_priority_change_log-form", book_priority_change_log: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/book_priority_changelog")

      html = render(index_live)
      assert html =~ "Book priority change log created successfully"
    end

    test "updates book_priority_change_log in listing", %{conn: conn, book_priority_change_log: book_priority_change_log} do
      {:ok, index_live, _html} = live(conn, ~p"/book_priority_changelog")

      assert index_live |> element("#book_priority_changelog-#{book_priority_change_log.id} a", "Edit") |> render_click() =~
               "Edit Book priority change log"

      assert_patch(index_live, ~p"/book_priority_changelog/#{book_priority_change_log}/edit")

      assert index_live
             |> form("#book_priority_change_log-form", book_priority_change_log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#book_priority_change_log-form", book_priority_change_log: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/book_priority_changelog")

      html = render(index_live)
      assert html =~ "Book priority change log updated successfully"
    end

    test "deletes book_priority_change_log in listing", %{conn: conn, book_priority_change_log: book_priority_change_log} do
      {:ok, index_live, _html} = live(conn, ~p"/book_priority_changelog")

      assert index_live |> element("#book_priority_changelog-#{book_priority_change_log.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#book_priority_changelog-#{book_priority_change_log.id}")
    end
  end

  describe "Show" do
    setup [:create_book_priority_change_log]

    test "displays book_priority_change_log", %{conn: conn, book_priority_change_log: book_priority_change_log} do
      {:ok, _show_live, html} = live(conn, ~p"/book_priority_changelog/#{book_priority_change_log}")

      assert html =~ "Show Book priority change log"
    end

    test "updates book_priority_change_log within modal", %{conn: conn, book_priority_change_log: book_priority_change_log} do
      {:ok, show_live, _html} = live(conn, ~p"/book_priority_changelog/#{book_priority_change_log}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Book priority change log"

      assert_patch(show_live, ~p"/book_priority_changelog/#{book_priority_change_log}/show/edit")

      assert show_live
             |> form("#book_priority_change_log-form", book_priority_change_log: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#book_priority_change_log-form", book_priority_change_log: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/book_priority_changelog/#{book_priority_change_log}")

      html = render(show_live)
      assert html =~ "Book priority change log updated successfully"
    end
  end
end

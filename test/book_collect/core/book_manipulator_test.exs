defmodule BookCollect.Core.BookFileTest do
  use ReadNever.DataCase
  doctest BookCollect.Core.BookFile

  describe "book_manipulator" do
    alias BookCollect.Core.BookFile
    import ReadNever.BookShelfFixtures

    test "create_attrs" do
      directory_name = "dir_name"
      directory_path = "/a/b/c"

      books_directory =
        books_directory_fixture(%{name: directory_name, directory_path: directory_path})

      book_path = "/a/b/c/d/e/book.pdf"
      {:ok, {attrs, books_dir}} = BookFile.create_book_attrs(book_path, books_directory)

      assert attrs == %{
               book_tags: [%{name: "dir_name"}, %{name: "d"}, %{name: "e"}],
               filepath: "/a/b/c/d/e/book.pdf",
               last_read_datetime: nil,
               name: "e/book.pdf"
             }

      assert books_dir == books_directory
    end
  end
end

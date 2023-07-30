defmodule ReadNever.BookShelfTest do
  use ReadNever.DataCase

  alias ReadNever.BookShelf

  describe "books_directories" do
    alias ReadNever.BookShelf.BooksDirectory

    import ReadNever.BookShelfFixtures

    @invalid_attrs %{name: nil, directory_path: nil}

    test "list_books_directories/0 returns all books_directories" do
      books_directory = books_directory_fixture()
      assert BookShelf.list_books_directories() == [books_directory]
    end

    test "get_books_directory!/1 returns the books_directory with given id" do
      books_directory = books_directory_fixture()
      assert BookShelf.get_books_directory!(books_directory.id) == books_directory
    end

    test "create_books_directory/1 with valid data creates a books_directory" do
      valid_attrs = %{name: "some name", directory_path: "some directory_path"}

      assert {:ok, %BooksDirectory{} = books_directory} =
               BookShelf.create_books_directory(valid_attrs)

      assert books_directory.name == "some name"
      assert books_directory.directory_path == "some directory_path"
    end

    test "create_books_directory/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BookShelf.create_books_directory(@invalid_attrs)
    end

    test "update_books_directory/2 with valid data updates the books_directory" do
      books_directory = books_directory_fixture()
      update_attrs = %{name: "some updated name", directory_path: "some updated directory_path"}

      assert {:ok, %BooksDirectory{} = books_directory} =
               BookShelf.update_books_directory(books_directory, update_attrs)

      assert books_directory.name == "some updated name"
      assert books_directory.directory_path == "some updated directory_path"
    end

    test "update_books_directory/2 with invalid data returns error changeset" do
      books_directory = books_directory_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BookShelf.update_books_directory(books_directory, @invalid_attrs)

      assert books_directory == BookShelf.get_books_directory!(books_directory.id)
    end

    test "delete_books_directory/1 deletes the books_directory" do
      books_directory = books_directory_fixture()
      assert {:ok, %BooksDirectory{}} = BookShelf.delete_books_directory(books_directory)

      assert_raise Ecto.NoResultsError, fn ->
        BookShelf.get_books_directory!(books_directory.id)
      end
    end

    test "change_books_directory/1 returns a books_directory changeset" do
      books_directory = books_directory_fixture()
      assert %Ecto.Changeset{} = BookShelf.change_books_directory(books_directory)
    end
  end

  describe "books" do
    alias ReadNever.BookShelf.Book

    import ReadNever.BookShelfFixtures

    @invalid_attrs %{name: nil, filepath: nil, last_read_datetime: nil}

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert BookShelf.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert BookShelf.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      valid_attrs = %{
        name: "some name",
        filepath: "some filepath",
        last_read_datetime: ~U[2023-07-22 08:34:00Z]
      }

      books_directory = books_directory_fixture()
      assert {:ok, %Book{} = book} = BookShelf.create_book(valid_attrs, books_directory)
      assert book.name == "some name"
      assert book.filepath == "some filepath"
      assert book.last_read_datetime == ~U[2023-07-22 08:34:00Z]
    end

    test "create_book/1 with invalid data returns error changeset" do
      books_directory = books_directory_fixture()
      assert {:error, %Ecto.Changeset{}} = BookShelf.create_book(@invalid_attrs, books_directory)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()

      update_attrs = %{
        name: "some updated name",
        filepath: "some updated filepath",
        last_read_datetime: ~U[2023-07-23 08:34:00Z]
      }

      assert {:ok, %Book{} = book} = BookShelf.update_book(book, update_attrs)
      assert book.name == "some updated name"
      assert book.filepath == "some updated filepath"
      assert book.last_read_datetime == ~U[2023-07-23 08:34:00Z]
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = BookShelf.update_book(book, @invalid_attrs)
      assert book == BookShelf.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = BookShelf.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> BookShelf.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = BookShelf.change_book(book)
    end
  end

  describe "book_priority_changelog" do
    alias ReadNever.BookShelf.BookPriorityChangeLog

    import ReadNever.BookShelfFixtures

    @invalid_attrs %{priority: nil, change_datetime: nil}

    test "list_book_priority_changelog/0 returns all book_priority_changelog" do
      book_priority_change_log = book_priority_change_log_fixture()
      assert BookShelf.list_book_priority_changelog() == [book_priority_change_log]
    end

    test "get_book_priority_change_log!/1 returns the book_priority_change_log with given id" do
      book_priority_change_log = book_priority_change_log_fixture()

      assert BookShelf.get_book_priority_change_log!(book_priority_change_log.id) ==
               book_priority_change_log
    end

    test "create_book_priority_change_log/1 with valid data creates a book_priority_change_log" do
      valid_attrs = %{priority: :new, change_datetime: ~U[2023-07-22 08:34:00Z]}
      book = book_fixture()

      assert {:ok, %BookPriorityChangeLog{} = book_priority_change_log} =
               BookShelf.create_book_priority_change_log(valid_attrs, book)

      assert book_priority_change_log.priority == :new
      assert book_priority_change_log.change_datetime == ~U[2023-07-22 08:34:00Z]
    end

    test "create_book_priority_change_log/1 with invalid data returns error changeset" do
      book = book_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BookShelf.create_book_priority_change_log(@invalid_attrs, book)
    end

    test "update_book_priority_change_log/2 with valid data updates the book_priority_change_log" do
      book_priority_change_log = book_priority_change_log_fixture()
      update_attrs = %{priority: :reading, change_datetime: ~U[2023-07-23 08:34:00Z]}

      assert {:ok, %BookPriorityChangeLog{} = book_priority_change_log} =
               BookShelf.update_book_priority_change_log(book_priority_change_log, update_attrs)

      assert book_priority_change_log.priority == :reading
      assert book_priority_change_log.change_datetime == ~U[2023-07-23 08:34:00Z]
    end

    test "update_book_priority_change_log/2 with invalid data returns error changeset" do
      book_priority_change_log = book_priority_change_log_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BookShelf.update_book_priority_change_log(book_priority_change_log, @invalid_attrs)

      assert book_priority_change_log ==
               BookShelf.get_book_priority_change_log!(book_priority_change_log.id)
    end

    test "delete_book_priority_change_log/1 deletes the book_priority_change_log" do
      book_priority_change_log = book_priority_change_log_fixture()

      assert {:ok, %BookPriorityChangeLog{}} =
               BookShelf.delete_book_priority_change_log(book_priority_change_log)

      assert_raise Ecto.NoResultsError, fn ->
        BookShelf.get_book_priority_change_log!(book_priority_change_log.id)
      end
    end

    test "change_book_priority_change_log/1 returns a book_priority_change_log changeset" do
      book_priority_change_log = book_priority_change_log_fixture()

      assert %Ecto.Changeset{} =
               BookShelf.change_book_priority_change_log(book_priority_change_log)
    end
  end

  describe "book_tags" do
    alias ReadNever.BookShelf.BookTag

    import ReadNever.BookShelfFixtures

    @invalid_attrs %{name: nil}

    test "list_book_tags/0 returns all book_tags" do
      book_tag = book_tag_fixture()
      assert BookShelf.list_book_tags() == [book_tag]
    end

    test "get_book_tag!/1 returns the book_tag with given id" do
      book_tag = book_tag_fixture()
      assert BookShelf.get_book_tag!(book_tag.id) == book_tag
    end

    test "create_book_tag/1 with valid data creates a book_tag" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %BookTag{} = book_tag} = BookShelf.create_book_tag(valid_attrs)
      assert book_tag.name == "some name"
    end

    test "create_book_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BookShelf.create_book_tag(@invalid_attrs)
    end

    test "update_book_tag/2 with valid data updates the book_tag" do
      book_tag = book_tag_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %BookTag{} = book_tag} = BookShelf.update_book_tag(book_tag, update_attrs)
      assert book_tag.name == "some updated name"
    end

    test "update_book_tag/2 with invalid data returns error changeset" do
      book_tag = book_tag_fixture()
      assert {:error, %Ecto.Changeset{}} = BookShelf.update_book_tag(book_tag, @invalid_attrs)
      assert book_tag == BookShelf.get_book_tag!(book_tag.id)
    end

    test "delete_book_tag/1 deletes the book_tag" do
      book_tag = book_tag_fixture()
      assert {:ok, %BookTag{}} = BookShelf.delete_book_tag(book_tag)
      assert_raise Ecto.NoResultsError, fn -> BookShelf.get_book_tag!(book_tag.id) end
    end

    test "delete_book_tags_not_used!/0 deletes the book_tags not used" do
      book_tag_used = book_tag_fixture(%{name: "used_tag"})
      book_tag_not_used = book_tag_fixture(%{name: "unused_tag"})

      assert BookShelf.list_book_tags() == [book_tag_used, book_tag_not_used]

      book = book_fixture(%{book_tags: [book_tag_used]})

      BookShelf.delete_book_tags_not_used!()

      assert BookShelf.list_book_tags() == [book_tag_used]
    end

    test "change_book_tag/1 returns a book_tag changeset" do
      book_tag = book_tag_fixture()
      assert %Ecto.Changeset{} = BookShelf.change_book_tag(book_tag)
    end
  end
end

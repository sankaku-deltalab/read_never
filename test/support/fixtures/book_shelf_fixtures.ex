defmodule ReadNever.BookShelfFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ReadNever.BookShelf` context.
  """

  @doc """
  Generate a unique books_directory directory_path.
  """
  def unique_books_directory_directory_path,
    do: "some directory_path#{System.unique_integer([:positive])}"

  @doc """
  Generate a books_directory.
  """
  def books_directory_fixture(attrs \\ %{}) do
    {:ok, books_directory} =
      attrs
      |> Enum.into(%{
        name: "some name",
        directory_path: unique_books_directory_directory_path()
      })
      |> ReadNever.BookShelf.create_books_directory()

    # Reload for assoc
    ReadNever.BookShelf.get_books_directory!(books_directory.id)
  end

  @doc """
  Generate a unique book filepath.
  """
  def unique_book_filepath, do: "some filepath#{System.unique_integer([:positive])}"

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      ReadNever.Repo.transaction(fn ->
        books_dir = books_directory_fixture()

        {:ok, book} =
          attrs
          |> Enum.into(%{
            name: "some name",
            filepath: unique_book_filepath(),
            last_read_datetime: ~U[2023-07-22 08:34:00Z]
          })
          |> ReadNever.BookShelf.create_book(books_dir)

        book
      end)

    # Reload for assoc
    ReadNever.BookShelf.get_book!(book.id)
  end

  @doc """
  Generate a book_priority_change_log.
  """
  def book_priority_change_log_fixture(attrs \\ %{}) do
    {:ok, book_priority_change_log} =
      ReadNever.Repo.transaction(fn ->
        book = book_fixture()

        {:ok, change_log} =
          attrs
          |> Enum.into(%{
            priority: :new,
            change_datetime: ~U[2023-07-22 08:34:00Z],
            book_id: book.id
          })
          |> ReadNever.BookShelf.create_book_priority_change_log(book)

        change_log
      end)

    # Reload for assoc
    ReadNever.BookShelf.get_book_priority_change_log!(book_priority_change_log.id)
  end

  @doc """
  Generate a unique book_tag name.
  """
  def unique_book_tag_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a book_tag.
  """
  def book_tag_fixture(attrs \\ %{}) do
    {:ok, book_tag} =
      attrs
      |> Enum.into(%{
        name: unique_book_tag_name()
      })
      |> ReadNever.BookShelf.create_book_tag()

    book_tag
  end
end

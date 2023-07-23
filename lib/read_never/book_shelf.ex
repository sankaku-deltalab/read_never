defmodule ReadNever.BookShelf do
  @moduledoc """
  The BookShelf context.
  """

  import Ecto.Query, warn: false
  alias ReadNever.Repo

  alias ReadNever.BookShelf.BooksDirectory

  @doc """
  Returns the list of books_directories.

  ## Examples

      iex> list_books_directories()
      [%BooksDirectory{}, ...]

  """
  def list_books_directories do
    Repo.all(BooksDirectory)
  end

  @doc """
  Gets a single books_directory.

  Raises `Ecto.NoResultsError` if the Books directory does not exist.

  ## Examples

      iex> get_books_directory!(123)
      %BooksDirectory{}

      iex> get_books_directory!(456)
      ** (Ecto.NoResultsError)

  """
  def get_books_directory!(id), do: Repo.get!(BooksDirectory, id)

  @doc """
  Creates a books_directory.

  ## Examples

      iex> create_books_directory(%{field: value})
      {:ok, %BooksDirectory{}}

      iex> create_books_directory(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_books_directory(attrs \\ %{}) do
    %BooksDirectory{}
    |> BooksDirectory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a books_directory.

  ## Examples

      iex> update_books_directory(books_directory, %{field: new_value})
      {:ok, %BooksDirectory{}}

      iex> update_books_directory(books_directory, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_books_directory(%BooksDirectory{} = books_directory, attrs) do
    books_directory
    |> BooksDirectory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a books_directory.

  ## Examples

      iex> delete_books_directory(books_directory)
      {:ok, %BooksDirectory{}}

      iex> delete_books_directory(books_directory)
      {:error, %Ecto.Changeset{}}

  """
  def delete_books_directory(%BooksDirectory{} = books_directory) do
    Repo.delete(books_directory)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking books_directory changes.

  ## Examples

      iex> change_books_directory(books_directory)
      %Ecto.Changeset{data: %BooksDirectory{}}

  """
  def change_books_directory(%BooksDirectory{} = books_directory, attrs \\ %{}) do
    BooksDirectory.changeset(books_directory, attrs)
  end

  alias ReadNever.BookShelf.Book

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id)

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{data: %Book{}}

  """
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end

  alias ReadNever.BookShelf.BookPriorityChangeLog

  @doc """
  Returns the list of book_priority_changelog.

  ## Examples

      iex> list_book_priority_changelog()
      [%BookPriorityChangeLog{}, ...]

  """
  def list_book_priority_changelog do
    Repo.all(BookPriorityChangeLog)
  end

  @doc """
  Gets a single book_priority_change_log.

  Raises `Ecto.NoResultsError` if the Book priority change log does not exist.

  ## Examples

      iex> get_book_priority_change_log!(123)
      %BookPriorityChangeLog{}

      iex> get_book_priority_change_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book_priority_change_log!(id), do: Repo.get!(BookPriorityChangeLog, id)

  @doc """
  Creates a book_priority_change_log.

  ## Examples

      iex> create_book_priority_change_log(%{field: value})
      {:ok, %BookPriorityChangeLog{}}

      iex> create_book_priority_change_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book_priority_change_log(attrs \\ %{}) do
    %BookPriorityChangeLog{}
    |> BookPriorityChangeLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book_priority_change_log.

  ## Examples

      iex> update_book_priority_change_log(book_priority_change_log, %{field: new_value})
      {:ok, %BookPriorityChangeLog{}}

      iex> update_book_priority_change_log(book_priority_change_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book_priority_change_log(%BookPriorityChangeLog{} = book_priority_change_log, attrs) do
    book_priority_change_log
    |> BookPriorityChangeLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book_priority_change_log.

  ## Examples

      iex> delete_book_priority_change_log(book_priority_change_log)
      {:ok, %BookPriorityChangeLog{}}

      iex> delete_book_priority_change_log(book_priority_change_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book_priority_change_log(%BookPriorityChangeLog{} = book_priority_change_log) do
    Repo.delete(book_priority_change_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book_priority_change_log changes.

  ## Examples

      iex> change_book_priority_change_log(book_priority_change_log)
      %Ecto.Changeset{data: %BookPriorityChangeLog{}}

  """
  def change_book_priority_change_log(%BookPriorityChangeLog{} = book_priority_change_log, attrs \\ %{}) do
    BookPriorityChangeLog.changeset(book_priority_change_log, attrs)
  end

  alias ReadNever.BookShelf.BookTag

  @doc """
  Returns the list of book_tags.

  ## Examples

      iex> list_book_tags()
      [%BookTag{}, ...]

  """
  def list_book_tags do
    Repo.all(BookTag)
  end

  @doc """
  Gets a single book_tag.

  Raises `Ecto.NoResultsError` if the Book tag does not exist.

  ## Examples

      iex> get_book_tag!(123)
      %BookTag{}

      iex> get_book_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book_tag!(id), do: Repo.get!(BookTag, id)

  @doc """
  Creates a book_tag.

  ## Examples

      iex> create_book_tag(%{field: value})
      {:ok, %BookTag{}}

      iex> create_book_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book_tag(attrs \\ %{}) do
    %BookTag{}
    |> BookTag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book_tag.

  ## Examples

      iex> update_book_tag(book_tag, %{field: new_value})
      {:ok, %BookTag{}}

      iex> update_book_tag(book_tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book_tag(%BookTag{} = book_tag, attrs) do
    book_tag
    |> BookTag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a book_tag.

  ## Examples

      iex> delete_book_tag(book_tag)
      {:ok, %BookTag{}}

      iex> delete_book_tag(book_tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book_tag(%BookTag{} = book_tag) do
    Repo.delete(book_tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book_tag changes.

  ## Examples

      iex> change_book_tag(book_tag)
      %Ecto.Changeset{data: %BookTag{}}

  """
  def change_book_tag(%BookTag{} = book_tag, attrs \\ %{}) do
    BookTag.changeset(book_tag, attrs)
  end
end
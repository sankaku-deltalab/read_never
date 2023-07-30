defmodule BookCollect.Core.BookGathering do
  alias ReadNever.BookShelf
  alias ReadNever.BookShelf.{Book, BooksDirectory}
  alias BookCollect.Core.BookFile

  @spec search_and_create_books([%BooksDirectory{}], (%Book{} -> any()), (() -> any())) :: term()
  def search_and_create_books(books_directories, added_callback, finish_callback) do
    items =
      books_directories
      |> Enum.map(fn %BooksDirectory{directory_path: path} = dir -> {path, dir} end)
      |> DeepSinker.new()
      |> DeepSinker.stream()
      |> Flow.from_enumerable()
      |> Flow.map(fn {path, dir} -> BookFile.create_book_attrs(path, dir) end)
      |> Flow.filter(fn {ok_err, _item} -> ok_err == :ok end)
      |> Flow.map(fn {:ok, {attrs, dir}} ->
        case BookShelf.create_book(attrs, dir) do
          {:ok, book} ->
            added_callback.(book)
            {:ok, book}

          {:error, changeset} ->
            {:error, changeset}
        end
      end)
      |> Enum.to_list()

    finish_callback.()
    items
  end

  @spec unregister_books_not_exist([%Book{}], (%Book{} -> any()), (() -> any())) :: term()
  def unregister_books_not_exist(books, delete_callback, finish_callback) do
    for book <- books do
      with false <- File.exists?(book.filepath),
           {:ok, _book} <- BookShelf.delete_book(book) do
        delete_callback.(book)
      end
    end

    BookShelf.delete_book_tags_not_used!()

    finish_callback.()
  end
end

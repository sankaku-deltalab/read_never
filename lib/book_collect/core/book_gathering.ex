defmodule BookCollect.Core.BookGathering do
  alias ReadNever.BookShelf
  alias ReadNever.BookShelf.{Book, BooksDirectory}
  alias BookCollect.Core.BookFile

  @spec search_and_create_books([%BooksDirectory{}], (() -> any())) :: term()
  def search_and_create_books(books_directories, finish_callback) do
    items =
      books_directories
      |> Enum.map(fn %BooksDirectory{directory_path: path} = dir -> {path, dir} end)
      |> DeepSinker.new()
      |> DeepSinker.stream()
      |> Flow.from_enumerable()
      |> Flow.map(fn {path, dir} -> BookFile.create_book_attrs(path, dir) end)
      |> Flow.filter(fn {ok_err, _item} -> ok_err == :ok end)
      |> Flow.map(fn {:ok, attrs_and_dir} -> attrs_and_dir end)
      |> Flow.map(fn {attrs, dir} -> BookShelf.create_book(attrs, dir) end)
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

    finish_callback.()
  end
end

defmodule BookCollect.Core.BookFile do
  alias ReadNever.BookShelf.{Book, BooksDirectory}

  @spec create_book_attrs(Path.t(), %BooksDirectory{}) ::
          {:ok, {Book.atom_attrs(), %BooksDirectory{}}} | {:error, term()}
  def create_book_attrs(filepath, %BooksDirectory{} = books_directory)
      when is_bitstring(filepath) do
    with {:is_book_filepath, true} <- {:is_book_filepath, is_book_filepath?(filepath)},
         {:is_subdirectory, true} <-
           {:is_subdirectory, is_subdirectory?(books_directory.directory_path, filepath)} do
      book_path_rel_dir = Path.relative_to(filepath, books_directory.directory_path)

      tags =
        [books_directory.name | get_tags_from_rel_path(book_path_rel_dir)]
        |> Enum.uniq()
        |> Enum.map(&%{name: &1})

      book_name = get_book_name_from_path(book_path_rel_dir)

      {:ok,
       {%{
          name: book_name,
          filepath: filepath,
          last_read_datetime: nil,
          book_tags: tags
        }, books_directory}}
    else
      {:is_book_filepath, false} -> {:error, :not_book_file}
      {:is_subdirectory, false} -> {:error, :not_in_parent_directory}
    end
  end

  @doc """
  ## Examples

      iex> alias BookCollect.Core.BookFile
      iex> BookFile.is_book_filepath?("/path/to/book.pdf")
      true
      iex> BookFile.is_book_filepath?("/path/to/book.epub")
      true
      iex> BookFile.is_book_filepath?("/path/to/not_book.png")
      false
  """
  def is_book_filepath?(filepath) when is_bitstring(filepath) do
    ext =
      filepath
      |> Path.extname()
      |> String.downcase()

    ext in [".pdf", ".epub"]
  end

  @doc """
  ## Examples

      iex> alias BookCollect.Core.BookFile
      iex> BookFile.is_subdirectory?("/path/to", "/path/to/book.pdf")
      true
      iex> BookFile.is_subdirectory?("/not_path/to", "/path/to/book.pdf")
      false
  """
  def is_subdirectory?(parent, child) do
    parent = Path.expand(parent) |> Path.absname() |> String.trim_trailing("/")
    child = Path.expand(child) |> Path.absname() |> String.trim_trailing("/")
    String.starts_with?(child, parent)
  end

  @doc """
  ## Examples

      iex> alias BookCollect.Core.BookFile
      iex> BookFile.get_tags_from_rel_path("a/b/c/d/e/f/book.pdf")
      ["a", "b", "c", "d", "e", "f"]
  """
  def get_tags_from_rel_path(filepath_rel) when is_bitstring(filepath_rel) do
    filepath_rel
    |> Path.dirname()
    |> Path.split()
  end

  @doc """
  ## Examples

      iex> alias BookCollect.Core.BookFile
      iex> BookFile.get_book_name_from_path("a/b/c/d/e/f/book.pdf")
      "f/book.pdf"
  """
  def get_book_name_from_path(filepath_rel) when is_bitstring(filepath_rel) do
    filepath_rel
    |> Path.split()
    |> Enum.take(-2)
    |> Enum.join("/")
  end
end

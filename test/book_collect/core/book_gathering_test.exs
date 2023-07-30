defmodule BookCollect.Core.BookGatheringTest do
  use ReadNever.DataCase
  doctest BookCollect.Core.BookGathering

  describe "book_gathering" do
    import ReadNever.BookShelfFixtures
    alias BookCollect.Core.BookGathering
    alias ReadNever.BookShelf
    alias BookCollect.TmpBookFilesFixtures

    @tag :tmp_dir
    test "collect books", %{tmp_dir: root} do
      filepath_list = TmpBookFilesFixtures.tmp_files_fixture(root) |> Enum.sort()

      directory_name = "dir_name"
      directory_path = root

      books_directory =
        books_directory_fixture(%{name: directory_name, directory_path: directory_path})

      added_callback = fn _book -> nil end
      finish_callback = fn -> nil end
      BookGathering.search_and_create_books([books_directory], added_callback, finish_callback)
      books = BookShelf.list_books() |> Enum.sort_by(& &1.filepath)

      book_filepath = books |> Enum.map(& &1.filepath)

      assert book_filepath == filepath_list
    end
  end
end

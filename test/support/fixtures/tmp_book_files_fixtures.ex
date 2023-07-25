defmodule BookCollect.TmpBookFilesFixtures do
  def tmp_files_fixture(root) do
    # - root
    #   - dir_1
    #     - dir_1_1
    #       - file_1_1_1.pdf
    #     - dir_1_2
    #     - file_1_1.pdf
    #   - dir_2
    #     - dir_2_1
    #   - dir_3
    #     - file_3_1.pdf
    #   - file_1.pdf
    #   - file_2.pdf
    rel_dirs = ["dir_1/dir_1_1", "dir_1/dir_1_2", "dir_2/dir_2_1", "dir_3"]

    for rel_dir <- rel_dirs do
      File.mkdir_p!(Path.join(root, rel_dir))
    end

    filepath_list =
      [
        "dir_1/dir_1_1/file_1_1_1.pdf",
        "dir_1/file_1_1.pdf",
        "dir_3/file_3_1.pdf",
        "file_1.pdf",
        "file_2.pdf"
      ]
      |> Enum.map(&Path.join(root, &1))

    for filepath <- filepath_list do
      File.write(filepath, "")
    end

    filepath_list
  end
end

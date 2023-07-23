defmodule ReadNever.Repo.Migrations.CreateBooksDirectories do
  use Ecto.Migration

  def change do
    create table(:books_directories) do
      add :directory_path, :string
      add :name, :string

      timestamps()
    end

    create unique_index(:books_directories, [:directory_path])
  end
end

defmodule ReadNever.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :filepath, :string
      add :name, :string
      add :last_read_datetime, :utc_datetime
      add :books_directory_id, references(:books_directories, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:books, [:filepath])
    create index(:books, [:books_directory_id])
  end
end

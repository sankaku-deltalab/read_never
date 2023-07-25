defmodule ReadNever.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :filepath, :string, null: false
      add :name, :string, null: false
      add :last_read_datetime, :utc_datetime, null: true
      add :books_directory_id, references(:books_directories, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:books, [:filepath])
    create index(:books, [:books_directory_id])
  end
end

defmodule ReadNever.Repo.Migrations.CreateBookTags do
  use Ecto.Migration

  def change do
    create table(:book_tags) do
      add :name, :string, null:false

      timestamps()
    end

    create unique_index(:book_tags, [:name])
  end
end

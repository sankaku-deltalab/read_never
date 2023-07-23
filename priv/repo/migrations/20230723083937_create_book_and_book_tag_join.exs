defmodule ReadNever.Repo.Migrations.CreateBookAndBookTagJoin do
  use Ecto.Migration

  def change do
    create table(:book_and_jook_tag_join) do
      add :book_id, references(:books, on_delete: :delete_all), null: false
      add :book_tag_id, references(:book_tags, on_delete: :delete_all), null: false
    end

    create index(:book_and_jook_tag_join, [:book_id])
    create index(:book_and_jook_tag_join, [:book_tag_id])
    create unique_index(:book_and_jook_tag_join, [:book_id, :book_tag_id])
  end
end

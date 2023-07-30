defmodule ReadNever.Repo.Migrations.CreateBookPriorityChangelog do
  use Ecto.Migration

  def change do
    create table(:book_priority_changelog) do
      add :change_datetime, :utc_datetime, null: false
      add :priority, :string, null: false
      add :book_id, references(:books, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:book_priority_changelog, [:book_id])
  end
end

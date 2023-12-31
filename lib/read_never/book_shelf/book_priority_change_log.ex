defmodule ReadNever.BookShelf.BookPriorityChangeLog do
  use Ecto.Schema
  import Ecto.Changeset
  alias ReadNever.BookShelf.Book

  schema "book_priority_changelog" do
    field :priority, Ecto.Enum, values: [:new, :reading, :read_next, :read_later, :read_never]
    field :change_datetime, :utc_datetime

    belongs_to :book, Book

    timestamps()
  end

  @doc false
  def changeset(book_priority_change_log, attrs) do
    book_priority_change_log
    |> cast(attrs, [:change_datetime, :priority])
    |> validate_required([:change_datetime, :priority])
  end
end

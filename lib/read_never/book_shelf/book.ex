defmodule ReadNever.BookShelf.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias ReadNever.BookShelf.{BooksDirectory, BookTag}

  schema "books" do
    field :name, :string
    field :filepath, :string
    field :last_read_datetime, :utc_datetime

    belongs_to :books_directory, BooksDirectory
    many_to_many :book_tags, BookTag, join_through: "book_and_jook_tag_join"

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:filepath, :name, :last_read_datetime])
    |> validate_required([:filepath, :name, :last_read_datetime])
    |> unique_constraint(:filepath)
  end
end

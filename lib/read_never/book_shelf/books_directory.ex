defmodule ReadNever.BookShelf.BooksDirectory do
  use Ecto.Schema
  import Ecto.Changeset
  alias ReadNever.BookShelf.Book

  schema "books_directories" do
    field :name, :string
    field :directory_path, :string

    has_many :books, Book

    timestamps()
  end

  @doc false
  def changeset(books_directory, attrs) do
    books_directory
    |> cast(attrs, [:directory_path, :name])
    |> validate_required([:directory_path, :name])
    |> unique_constraint(:directory_path)
  end
end

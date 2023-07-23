defmodule ReadNever.BookShelf.BookTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias ReadNever.BookShelf.Book

  schema "book_tags" do
    field :name, :string

    many_to_many :books, Book, join_through: "book_and_jook_tag_join"
    timestamps()
  end

  @doc false
  def changeset(book_tag, attrs) do
    book_tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

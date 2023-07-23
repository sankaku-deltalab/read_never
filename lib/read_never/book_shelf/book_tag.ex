defmodule ReadNever.BookShelf.BookTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_tags" do
    field :name, :string

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

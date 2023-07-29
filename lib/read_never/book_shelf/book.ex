defmodule ReadNever.BookShelf.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias ReadNever.BookShelf.{BooksDirectory, BookTag, BookPriorityChangeLog}

  @type atom_attrs :: %{
          optional(:name) => String.t(),
          optional(:filepath) => String.t(),
          optional(:last_read_datetime) => %DateTime{} | nil,
          optional(:book_tags) => [%{name: String.t()}]
        }

  schema "books" do
    field(:name, :string)
    field(:filepath, :string)
    field(:last_read_datetime, :utc_datetime)
    field(:tags_as_text, :string, virtual: true)

    belongs_to(:books_directory, BooksDirectory)
    many_to_many(:book_tags, BookTag, join_through: "book_and_jook_tag_join")

    has_many(:book_priority_change_logs, BookPriorityChangeLog)

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:filepath, :name, :last_read_datetime])
    |> validate_required([:filepath, :name])
    |> unique_constraint(:filepath)
  end

  def current_priority(
        %__MODULE__{book_priority_change_logs: %Ecto.Association.NotLoaded{}} = _book
      ) do
    :new
  end

  def current_priority(%__MODULE__{book_priority_change_logs: []} = _book) do
    :new
  end

  def current_priority(%__MODULE__{book_priority_change_logs: priorities = [_ | _]} = _book) do
    priorities
    |> Enum.sort_by(fn p -> p.change_datetime end, :desc)
    |> Enum.map(fn p -> p.priority end)
    |> List.first(:new)
  end
end

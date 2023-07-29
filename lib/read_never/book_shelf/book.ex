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
    field(:tags_as_text, :string, default: "", virtual: true)

    belongs_to(:books_directory, BooksDirectory)

    many_to_many(:book_tags, BookTag,
      join_through: "book_and_jook_tag_join",
      on_replace: :delete,
      unique: true
    )

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

  def changeset_use_tags_as_text(%__MODULE__{} = book, %{} = attrs) do
    book
    |> cast(attrs, [:filepath, :name, :last_read_datetime, :tags_as_text])
    |> validate_required([:filepath, :name])
    |> unique_constraint(:filepath)
  end

  defp build_tags_from_text(tags_as_text, book)
       when is_bitstring(tags_as_text) do
    old_tags_map =
      book.book_tags
      |> Enum.map(fn t -> {t.name, t} end)
      |> Map.new()

    tags_as_text
    |> split_tags_as_text()
    |> Enum.map(fn n ->
      cond do
        Map.has_key?(old_tags_map, n) -> Map.fetch!(old_tags_map, n)
        true -> %BookTag{name: n}
      end
    end)
  end

  defp build_tags_from_text(_tags_as_text, _book) do
    []
  end

  def split_tags_as_text(tags_as_text) when is_bitstring(tags_as_text) do
    tags_as_text
    |> String.trim()
    |> String.split()
    |> Enum.uniq()
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

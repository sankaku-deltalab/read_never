defmodule ReadNeverWeb.BookLive.Index do
  use ReadNeverWeb, :live_view

  alias ReadNever.BookShelf
  alias ReadNever.BookShelf.Book

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :ok = ReadNeverWeb.Endpoint.subscribe("book_gathering")
    end

    sort_table = %{
      new: 1,
      read_next: 2,
      read_later: 3,
      read_never: 4
    }

    books =
      BookShelf.list_books()
      |> Enum.sort_by(&sort_table[Book.current_priority(&1)])

    {:ok, stream(socket, :books, books)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Book")
    |> assign(:book, BookShelf.get_book!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book")
    |> assign(:book, %Book{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Books")
    |> assign(:book, nil)
  end

  @impl true
  def handle_info({ReadNeverWeb.BookLive.FormComponent, {:saved, book}}, socket) do
    {:noreply, stream_insert(socket, :books, book)}
  end

  def handle_info(
        %{topic: "book_gathering", event: "book_added", payload: %{book: book}},
        socket
      ) do
    socket = socket |> stream_insert(:books, book)
    {:noreply, socket}
  end

  def handle_info(
        %{topic: "book_gathering", event: "book_deleted", payload: %{book: book}},
        socket
      ) do
    socket = socket |> stream_delete(:books, book)
    {:noreply, socket}
  end

  def handle_info(
        %{topic: "book_gathering", event: "status_changed", payload: %{status: _status}},
        socket
      ) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book = BookShelf.get_book!(id)
    {:ok, _} = BookShelf.delete_book(book)

    {:noreply, stream_delete(socket, :books, book)}
  end

  @impl true
  def handle_event("open_book", %{"id" => id}, socket) do
    book = BookShelf.get_book!(id)
    {:ok, _} = BookShelf.update_book(book, %{last_read_datetime: DateTime.now!("Etc/UTC")})

    # NOTE: only for windows
    System.cmd("cmd.exe", ["/c", book.filepath])
    {:noreply, socket}
  end

  @impl true
  def handle_event("set_book_priority", %{"id" => id, "priority" => priority}, socket) do
    book = BookShelf.get_book!(id)

    {:ok, _} =
      BookShelf.create_book_priority_change_log(
        %{change_datetime: DateTime.now!("Etc/UTC"), priority: priority},
        book
      )

    reloaded_book = BookShelf.get_book!(id)
    socket = socket |> stream_insert(:books, reloaded_book)

    {:noreply, socket}
  end

  def last_read_dt_str(%DateTime{} = last_read_dt) do
    # as Japan time
    last_read_dt
    |> DateTime.add(9, :hour)
    |> DateTime.to_iso8601()
    |> String.replace("T", " ")
    |> String.replace("Z", "")
  end

  def last_read_dt_str(nil = _last_read_dt) do
    ""
  end

  def shorten_tags_text(tags_text) when is_bitstring(tags_text) do
    Book.split_tags_as_text(tags_text)
    |> Enum.map(fn t ->
      cond do
        String.length(t) > 8 -> String.slice(t, 0..4) <> "..."
        true -> t
      end
    end)
    |> Enum.join(" ")
  end

  def book_priority_text(%Book{} = book) do
    texts =
      Map.new([
        {:new, "New"},
        {:reading, "Reading"},
        {:read_next, "Read next"},
        {:read_later, "Read later"},
        {:read_never, "Read never"}
      ])

    book
    |> Book.current_priority()
    |> then(fn p -> Map.fetch!(texts, p) end)
  end
end

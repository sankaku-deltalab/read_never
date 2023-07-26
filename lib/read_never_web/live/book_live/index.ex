defmodule ReadNeverWeb.BookLive.Index do
  use ReadNeverWeb, :live_view

  alias ReadNever.BookShelf
  alias ReadNever.BookShelf.Book

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :books, BookShelf.list_books())}
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

    # TODO: test on windows
    System.cmd("cmd", ["start", book.filepath])
    {:noreply, socket}
  end
end

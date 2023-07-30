defmodule ReadNeverWeb.BooksDirectoryLive.Index do
  use ReadNeverWeb, :live_view

  alias ReadNever.BookShelf
  alias ReadNever.BookShelf.BooksDirectory

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      :ok = ReadNeverWeb.Endpoint.subscribe("book_gathering")
    end

    socket =
      socket
      |> stream(:books_directories, BookShelf.list_books_directories())
      |> assign(:gathering_status, :inactive)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Books directory")
    |> assign(:books_directory, BookShelf.get_books_directory!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Books directory")
    |> assign(:books_directory, %BooksDirectory{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Books directories")
    |> assign(:books_directory, nil)
  end

  @impl true
  def handle_info(
        {ReadNeverWeb.BooksDirectoryLive.FormComponent, {:saved, books_directory}},
        socket
      ) do
    {:noreply, stream_insert(socket, :books_directories, books_directory)}
  end

  def handle_info(
        %{topic: "book_gathering", event: "book_deleted", payload: %{book: _book}},
        socket
      ) do
    {:noreply, socket}
  end

  def handle_info(
        %{topic: "book_gathering", event: "status_changed", payload: %{status: status}},
        socket
      ) do
    socket =
      socket
      |> assign(:gathering_status, status)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    books_directory = BookShelf.get_books_directory!(id)
    {:ok, _} = BookShelf.delete_books_directory(books_directory)

    {:noreply, stream_delete(socket, :books_directories, books_directory)}
  end

  @impl true
  def handle_event("load_books", _params, socket) do
    BookShelf.list_books_directories()
    |> BookCollect.Boundary.BookGatherer.request_gathering()

    {:noreply, socket}
  end

  @impl true
  def handle_event("release_books", _params, socket) do
    BookShelf.list_books()
    |> BookCollect.Boundary.BookGatherer.request_releasing()

    {:noreply, socket}
  end

  def can_start_gathering?(gathering_status) do
    gathering_status == :inactive
  end

  def can_start_releasing?(gathering_status) do
    gathering_status == :inactive
  end
end

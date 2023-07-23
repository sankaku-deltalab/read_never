defmodule ReadNeverWeb.BooksDirectoryLive.Index do
  use ReadNeverWeb, :live_view

  alias ReadNever.BookShelf
  alias ReadNever.BookShelf.BooksDirectory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :books_directories, BookShelf.list_books_directories())}
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
  def handle_info({ReadNeverWeb.BooksDirectoryLive.FormComponent, {:saved, books_directory}}, socket) do
    {:noreply, stream_insert(socket, :books_directories, books_directory)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    books_directory = BookShelf.get_books_directory!(id)
    {:ok, _} = BookShelf.delete_books_directory(books_directory)

    {:noreply, stream_delete(socket, :books_directories, books_directory)}
  end
end

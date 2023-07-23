defmodule ReadNeverWeb.BookTagLive.Index do
  use ReadNeverWeb, :live_view

  alias ReadNever.BookShelf
  alias ReadNever.BookShelf.BookTag

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :book_tags, BookShelf.list_book_tags())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Book tag")
    |> assign(:book_tag, BookShelf.get_book_tag!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book tag")
    |> assign(:book_tag, %BookTag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Book tags")
    |> assign(:book_tag, nil)
  end

  @impl true
  def handle_info({ReadNeverWeb.BookTagLive.FormComponent, {:saved, book_tag}}, socket) do
    {:noreply, stream_insert(socket, :book_tags, book_tag)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book_tag = BookShelf.get_book_tag!(id)
    {:ok, _} = BookShelf.delete_book_tag(book_tag)

    {:noreply, stream_delete(socket, :book_tags, book_tag)}
  end
end

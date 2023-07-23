defmodule ReadNeverWeb.BookPriorityChangeLogLive.Index do
  use ReadNeverWeb, :live_view

  alias ReadNever.BookShelf
  alias ReadNever.BookShelf.BookPriorityChangeLog

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :book_priority_changelog, BookShelf.list_book_priority_changelog())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Book priority change log")
    |> assign(:book_priority_change_log, BookShelf.get_book_priority_change_log!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Book priority change log")
    |> assign(:book_priority_change_log, %BookPriorityChangeLog{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Book priority changelog")
    |> assign(:book_priority_change_log, nil)
  end

  @impl true
  def handle_info({ReadNeverWeb.BookPriorityChangeLogLive.FormComponent, {:saved, book_priority_change_log}}, socket) do
    {:noreply, stream_insert(socket, :book_priority_changelog, book_priority_change_log)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    book_priority_change_log = BookShelf.get_book_priority_change_log!(id)
    {:ok, _} = BookShelf.delete_book_priority_change_log(book_priority_change_log)

    {:noreply, stream_delete(socket, :book_priority_changelog, book_priority_change_log)}
  end
end

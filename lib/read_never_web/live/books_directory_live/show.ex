defmodule ReadNeverWeb.BooksDirectoryLive.Show do
  use ReadNeverWeb, :live_view

  alias ReadNever.BookShelf

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:books_directory, BookShelf.get_books_directory!(id))}
  end

  defp page_title(:show), do: "Show Books directory"
  defp page_title(:edit), do: "Edit Books directory"
end

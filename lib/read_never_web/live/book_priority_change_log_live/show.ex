defmodule ReadNeverWeb.BookPriorityChangeLogLive.Show do
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
     |> assign(:book_priority_change_log, BookShelf.get_book_priority_change_log!(id))}
  end

  defp page_title(:show), do: "Show Book priority change log"
  defp page_title(:edit), do: "Edit Book priority change log"
end

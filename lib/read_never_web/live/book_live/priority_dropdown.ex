defmodule ReadNeverWeb.BookLive.PriorityDropdown do
  use ReadNeverWeb, :live_component

  @doc """
  Based on `https://tailwindui.com/components/application-ui/elements/dropdowns`.
  """

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      class="absolute right-0 z-10 mt-2 w-28 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
      role="menu"
      aria-orientation="vertical"
      aria-labelledby="menu-button"
      tabindex="-1"
      hidden
    >
      <div class="py-1" role="none">
        <!-- Active: "bg-gray-100 text-gray-900", Not Active: "text-gray-700" -->
        <%= for {priority, name} <- [{:new, "New"}, {:reading, "Reading"}, {:read_next, "Read-next"}, {:read_later, "Read-later"}, {:read_never, "Read-never"}] do %>
          <a
            href="#"
            class="text-gray-700 block px-4 py-2 text-sm"
            role="menuitem"
            tabindex="-1"
            id="menu-item-0"
          >
            <button phx-click={
              JS.push("set_book_priority", value: %{id: @book.id, priority: priority})
            }>
              <%= name %>
            </button>
          </a>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end
end

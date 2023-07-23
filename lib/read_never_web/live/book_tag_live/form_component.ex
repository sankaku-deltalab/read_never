defmodule ReadNeverWeb.BookTagLive.FormComponent do
  use ReadNeverWeb, :live_component

  alias ReadNever.BookShelf

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage book_tag records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="book_tag-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Book tag</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{book_tag: book_tag} = assigns, socket) do
    changeset = BookShelf.change_book_tag(book_tag)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"book_tag" => book_tag_params}, socket) do
    changeset =
      socket.assigns.book_tag
      |> BookShelf.change_book_tag(book_tag_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"book_tag" => book_tag_params}, socket) do
    save_book_tag(socket, socket.assigns.action, book_tag_params)
  end

  defp save_book_tag(socket, :edit, book_tag_params) do
    case BookShelf.update_book_tag(socket.assigns.book_tag, book_tag_params) do
      {:ok, book_tag} ->
        notify_parent({:saved, book_tag})

        {:noreply,
         socket
         |> put_flash(:info, "Book tag updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_book_tag(socket, :new, book_tag_params) do
    case BookShelf.create_book_tag(book_tag_params) do
      {:ok, book_tag} ->
        notify_parent({:saved, book_tag})

        {:noreply,
         socket
         |> put_flash(:info, "Book tag created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

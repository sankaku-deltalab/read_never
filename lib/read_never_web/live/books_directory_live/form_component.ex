defmodule ReadNeverWeb.BooksDirectoryLive.FormComponent do
  use ReadNeverWeb, :live_component

  alias ReadNever.BookShelf

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage books_directory records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="books_directory-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:directory_path]} type="text" label="Directory path" />
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Books directory</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{books_directory: books_directory} = assigns, socket) do
    changeset = BookShelf.change_books_directory(books_directory)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"books_directory" => books_directory_params}, socket) do
    changeset =
      socket.assigns.books_directory
      |> BookShelf.change_books_directory(books_directory_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"books_directory" => books_directory_params}, socket) do
    save_books_directory(socket, socket.assigns.action, books_directory_params)
  end

  defp save_books_directory(socket, :edit, books_directory_params) do
    case BookShelf.update_books_directory(socket.assigns.books_directory, books_directory_params) do
      {:ok, books_directory} ->
        notify_parent({:saved, books_directory})

        {:noreply,
         socket
         |> put_flash(:info, "Books directory updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_books_directory(socket, :new, books_directory_params) do
    case BookShelf.create_books_directory(books_directory_params) do
      {:ok, books_directory} ->
        notify_parent({:saved, books_directory})

        {:noreply,
         socket
         |> put_flash(:info, "Books directory created successfully")
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

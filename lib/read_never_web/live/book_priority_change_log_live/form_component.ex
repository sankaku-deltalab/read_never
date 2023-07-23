defmodule ReadNeverWeb.BookPriorityChangeLogLive.FormComponent do
  use ReadNeverWeb, :live_component

  alias ReadNever.BookShelf

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage book_priority_change_log records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="book_priority_change_log-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:change_datetime]} type="datetime-local" label="Change datetime" />
        <.input
          field={@form[:priority]}
          type="select"
          label="Priority"
          prompt="Choose a value"
          options={Ecto.Enum.values(ReadNever.BookShelf.BookPriorityChangeLog, :priority)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Book priority change log</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{book_priority_change_log: book_priority_change_log} = assigns, socket) do
    changeset = BookShelf.change_book_priority_change_log(book_priority_change_log)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"book_priority_change_log" => book_priority_change_log_params}, socket) do
    changeset =
      socket.assigns.book_priority_change_log
      |> BookShelf.change_book_priority_change_log(book_priority_change_log_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"book_priority_change_log" => book_priority_change_log_params}, socket) do
    save_book_priority_change_log(socket, socket.assigns.action, book_priority_change_log_params)
  end

  defp save_book_priority_change_log(socket, :edit, book_priority_change_log_params) do
    case BookShelf.update_book_priority_change_log(socket.assigns.book_priority_change_log, book_priority_change_log_params) do
      {:ok, book_priority_change_log} ->
        notify_parent({:saved, book_priority_change_log})

        {:noreply,
         socket
         |> put_flash(:info, "Book priority change log updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_book_priority_change_log(socket, :new, book_priority_change_log_params) do
    case BookShelf.create_book_priority_change_log(book_priority_change_log_params) do
      {:ok, book_priority_change_log} ->
        notify_parent({:saved, book_priority_change_log})

        {:noreply,
         socket
         |> put_flash(:info, "Book priority change log created successfully")
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

defmodule BookCollect.Boundary.BookGatherer do
  use GenServer

  alias BookCollect.Core.BookGathering
  alias ReadNever.BookShelf.Book

  @me __MODULE__
  @type status :: :inactive | :gathering | :releasing

  @type state :: %{active_task: Task.t() | nil}

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: @me)
  end

  def request_gathering(books_directories) do
    GenServer.call(@me, {:request_gathering, books_directories})
  end

  @spec request_releasing([%Book{}]) :: any
  def request_releasing(books) do
    GenServer.call(@me, {:request_releasing, books})
  end

  def request_abort() do
    GenServer.call(@me, :request_abort)
  end

  def finished() do
    GenServer.cast(@me, :finished)
  end

  def is_running?() do
    GenServer.call(@me, :is_running)
  end

  # impl

  @impl true
  def init(_) do
    {:ok, %{active_task: nil}}
  end

  @impl true
  def handle_call(
        {:request_gathering, books_directories},
        _from,
        %{active_task: active_task} = state
      ) do
    if active_task != nil, do: Task.shutdown(active_task, :brutal_kill)

    task =
      Task.async(fn -> BookGathering.search_and_create_books(books_directories, &finished/0) end)

    maybe_status_changed(:gathering)
    state = %{state | active_task: task}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(
        {:request_releasing, books},
        _from,
        %{active_task: active_task} = state
      ) do
    if active_task != nil, do: Task.shutdown(active_task, :brutal_kill)

    task =
      Task.async(fn ->
        BookGathering.unregister_books_not_exist(books, &book_deleted/1, &finished/0)
      end)

    maybe_status_changed(:gathering)
    state = %{state | active_task: task}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:request_abort, _from, %{active_task: active_task} = state) do
    if active_task != nil, do: Task.shutdown(active_task, :brutal_kill)

    maybe_status_changed(:inactive)
    state = %{state | active_task: nil}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:is_running, _from, %{active_task: active_task} = state) do
    is_running = active_task != nil
    {:reply, is_running, state}
  end

  @impl true
  def handle_cast(:finished, %{active_task: active_task} = state) do
    if active_task != nil, do: Task.shutdown(active_task)

    maybe_status_changed(:inactive)
    state = %{state | active_task: nil}
    {:noreply, state}
  end

  @impl true
  def handle_cast(event, state) do
    IO.inspect(event, state)
    {:noreply, state}
  end

  @impl true
  def terminate(_reason, %{active_task: active_task} = _state) do
    IO.puts("============ terminate ============")
    if active_task != nil, do: Task.shutdown(active_task, :brutal_kill)

    maybe_status_changed(:inactive)
  end

  defp maybe_status_changed(status)
       when status in [:inactive, :gathering, :releasing] do
    ReadNeverWeb.Endpoint.broadcast!(
      "book_gathering",
      "status_changed",
      %{status: status}
    )
  end

  defp book_deleted(%Book{} = book) do
    IO.inspect(book, label: "book_del")

    ReadNeverWeb.Endpoint.broadcast!(
      "book_gathering",
      "book_deleted",
      %{book: book}
    )
  end
end

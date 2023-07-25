defmodule BookCollect.Boundary.BookGatherer do
  use GenServer

  alias BookCollect.Core.BookGathering

  @me __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def request_start(books_directories) do
    GenServer.call(@me, {:request_start, books_directories})
  end

  def request_abort() do
    GenServer.call(@me, :request_abort)
  end

  def finished() do
    GenServer.call(@me, :finished)
  end

  def is_running?() do
    GenServer.call(@me, :is_running)
  end

  # impl

  @impl true
  def init(_) do
    {:ok, %{gatherer_pid: nil}}
  end

  @impl true
  def handle_call(
        {:request_start, books_directories},
        _from,
        %{gatherer_pid: gatherer_pid} = state
      ) do
    if gatherer_pid != nil, do: Task.shutdown(gatherer_pid, :brutal_kill)

    {:ok, pid} =
      Task.start(fn -> BookGathering.search_and_create_books(books_directories, &finished/0) end)

    maybe_status_changed(true)
    state = %{state | gatherer_pid: pid}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:request_abort, _from, %{gatherer_pid: gatherer_pid} = state) do
    if gatherer_pid != nil, do: Task.shutdown(gatherer_pid, :brutal_kill)

    maybe_status_changed(false)
    state = %{state | gatherer_pid: nil}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:finished, _from, %{gatherer_pid: gatherer_pid} = state) do
    if gatherer_pid != nil, do: Task.await(gatherer_pid)

    maybe_status_changed(false)
    state = %{state | gatherer_pid: nil}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:is_running, _from, %{gatherer_pid: gatherer_pid} = state) do
    is_running = gatherer_pid != nil
    {:reply, is_running, state}
  end

  defp maybe_status_changed(is_running) when is_boolean(is_running) do
    # TODO: call pubsub
  end
end

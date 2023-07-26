defmodule BookCollect.Lifecycle.BookCollectSup do
  use Supervisor

  alias BookCollect.Boundary.BookGatherer

  def start_link(_) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [BookGatherer]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

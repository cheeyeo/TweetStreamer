defmodule TweetStreamer.Supervisor do
  use Supervisor
  @name TweetStreamerSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_server do
    Supervisor.start_child(@name, [])
  end

  def init(_) do
    children = [
      worker(TweetStreamer.Server, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end

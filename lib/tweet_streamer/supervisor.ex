defmodule TweetStreamer.Supervisor do
  use Supervisor
  @name TweetSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_streamer do
    Supervisor.start_child(@name, [])
  end

  def init(_) do
    children = [
      worker(TweetStreamer.Server, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end

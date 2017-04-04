defmodule TweetStreamer.TwitterClientSupervisor do
  use Supervisor
  @name TwitterClientSupervisor
  require Logger

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_tracker() do
    Supervisor.start_child(@name, [])
    Logger.debug "COUNT: #{inspect(Supervisor.count_children(@name))} #{inspect(Supervisor.which_children(@name))}"
  end

  # Stops and restarts the tracker on new terms being added
  def stop_tracker() do
    children = Supervisor.which_children(@name)
    if !Enum.empty?(children) do
      Enum.each(children, fn(child) ->
        {_, pid, :worker, _} = child
        Supervisor.terminate_child(@name, pid)
      end)
    end
  end

  def init(_) do
    children = [
      worker(Task, [fn -> TweetStreamer.TwitterClient.stream |> Stream.run end],
        restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end

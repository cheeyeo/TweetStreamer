defmodule TwitterPlayground do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(TwitterPlayground.Repo, []),
      # Start the endpoint when the application starts
      supervisor(TwitterPlayground.Endpoint, []),
      worker(TweetStreamer.Queue, []),
      worker(TweetStreamer.TwitterFilter, []),
      worker(TweetStreamer.TwitterConsumer, []),
      supervisor(Registry, [:unique, :extwitter_process]),
      worker(Task.Supervisor, [[name: StreamSupervisor, restart: :transient]]),
      worker(TweetStreamer.OauthCredentials, [Application.get_env(:twitter_playground, :agent_name)])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_tracker() do
    # We check the supervisor to see if it has started
    # if not we create / start child process
    unless tracker_running?(StreamSupervisor) do
      {:ok, _pid} = Task.Supervisor.start_child(StreamSupervisor, fn() ->
        TweetStreamer.TwitterClient.stream
        |> Stream.run
      end)
    end
  end

  def stop_tracker() do
    if tracker_running?(StreamSupervisor) do
      pid = Task.Supervisor.children(StreamSupervisor) |> hd
      Task.Supervisor.terminate_child(StreamSupervisor, pid)
    end
    # Logger.debug("AFTER CHILDREN: #{inspect(Task.Supervisor.children(StreamSupervisor))}")
  end

  def tracker_running?(supervisor) do
    children = Task.Supervisor.children(supervisor)
    Enum.any?(children)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwitterPlayground.Endpoint.config_change(changed, removed)
    :ok
  end
end

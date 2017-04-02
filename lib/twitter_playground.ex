defmodule TwitterPlayground do
  use Application

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
      # Start your own worker by calling: TwitterPlayground.Worker.start_link(arg1, arg2, arg3)
      # worker(TwitterPlayground.Worker, [arg1, arg2, arg3]),
      supervisor(TweetStreamer.Supervisor, []),
      supervisor(TweetStreamer.TwitterClientSupervisor, []),
      worker(TweetStreamer.Queue, []),
      worker(TweetStreamer.TwitterFilter, []),
      worker(TweetStreamer.TwitterConsumer, []),
      supervisor(Registry, [:unique, :extwitter_process])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def track(query) do
    TweetStreamer.Server.add(query)
  end

  def untrack(query) do
    TweetStreamer.Server.remove(query)
  end

  def start_tracker() do
    TweetStreamer.TwitterClientSupervisor.start_tracker()
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwitterPlayground.Endpoint.config_change(changed, removed)
    :ok
  end
end

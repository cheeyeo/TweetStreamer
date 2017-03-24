defmodule TwitterPlayground do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
      access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
    )


    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(TwitterPlayground.Repo, []),
      # Start the endpoint when the application starts
      supervisor(TwitterPlayground.Endpoint, []),
      # Start your own worker by calling: TwitterPlayground.Worker.start_link(arg1, arg2, arg3)
      # worker(TwitterPlayground.Worker, [arg1, arg2, arg3]),
      supervisor(TweetStreamer.Supervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TwitterPlayground.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_streamer(query) do
    case :global.whereis_name(query) do
      :undefined ->
        {:ok, pid} = TweetStreamer.Supervisor.start_streamer
        :yes = :global.register_name(query, pid)
        {:ok, pid}
      pid ->
        {:ok, pid}
    end
  end

  # def track(query) do
  #   TweetStreamer.Server.filter({:global, query}, query)
  # end

  def track(query, socket_ref, orig_pid) do
    TweetStreamer.Server.filter({:global, query}, query, socket_ref, orig_pid)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TwitterPlayground.Endpoint.config_change(changed, removed)
    :ok
  end
end

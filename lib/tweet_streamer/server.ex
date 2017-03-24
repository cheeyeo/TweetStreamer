defmodule TweetStreamer.Server do
  use GenServer

  # Public API
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def filter(pid, query, socket_ref, orig_pid) do
    GenServer.cast(pid, {:stream_filter, query, socket_ref, orig_pid})
  end

  def handle_cast({:stream_filter, query, socket_ref, orig_pid}, _state) do
    start(query, socket_ref, orig_pid)
    {:noreply, query}
  end

  defp start(query, socket_ref, orig_pid) do
    stream = ExTwitter.stream_filter(track: query, timeout: 5000)
    Phoenix.Channel.reply socket_ref, {:ok, %{msg: "Starting tracking on term: #{query}"}}

    for tweet <- stream do
      # IO.puts "Tweet: #{inspect(tweet, pretty: true, limit: 2_000)}"
      send orig_pid, {:tweet_received, tweet, socket_ref}

      # Phoenix.Channel.reply socket, {:ok, %{tweet: tweet}}
      # broadcasts directly to Javascript channel
      # TwitterPlayground.Endpoint.broadcast!("tweets:"<>query, "tweet", %{tweet: tweet})
    end
  end
end

defmodule TweetStreamer.Server do
  use GenServer

  # Public API
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def filter(pid, query) do
    GenServer.cast(pid, {:stream_filter, query})
  end

  # Server API
  def handle_cast({:stream_filter, query}, _state) do
    start(query)
    {:noreply, query}
  end

  defp start(query) do
    stream = ExTwitter.stream_filter(track: query, timeout: 5000)
    for tweet <- stream do
      IO.inspect tweet
      # Phoenix.Channels.reply socket, {:some_topic, %{}}
      # this works:
      TwitterPlayground.Endpoint.broadcast!("tweets:"<>query, "tweet", %{tweet: tweet})
    end
  end
end

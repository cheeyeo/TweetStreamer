defmodule TwitterPlayground.TweetStreamer do
  def start(query) do
    IO.inspect "QUERY: #{query}"
    stream = ExTwitter.stream_filter(track: query)
    for tweet <- stream do
      IO.inspect tweet
      # this works:
      TwitterPlayground.Endpoint.broadcast!("tweets:"<>query, "tweet", %{tweet: tweet})
    end
  end
end

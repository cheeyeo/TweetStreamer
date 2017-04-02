defmodule TweetStreamer.TwitterClient do
  require Logger

  def stream do
    terms = TweetStreamer.Server.get_queries()
    concated_terms = terms |> Enum.join(",")

    ExTwitter.stream_filter(track: concated_terms)
    |> Stream.each(fn(tweet) ->
      Logger.info "zomg a tweet"
      Logger.debug "#{inspect(tweet)}"
      Enum.each(terms, fn(channel) ->
        Logger.info "channel: #{inspect(channel)}"
        TwitterPlayground.Endpoint.broadcast!("tweets:"<>channel, "tweet", %{tweet: tweet})
      end)
    end)
  end
end
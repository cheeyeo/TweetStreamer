defmodule TweetStreamer.TwitterClient do
  require Logger
  alias TweetStreamer.Queue
  alias TwitterPlayground.{Repo, Channel}

  def stream do
    terms =
      Repo.all(Channel)
      |> Enum.map(fn(c) -> c.name end)

    concated_terms =
      terms
      |> Enum.join(",")

    Logger.debug("TERMS: #{inspect(concated_terms)}")

    ExTwitter.stream_filter(track: concated_terms, timeout: :infinity)
    |> Stream.each(fn(tweet) ->
      # Logger.info "zomg a tweet"
      # Logger.debug "#{inspect(tweet)}"

      # Add it to queue which then calls filter to
      # match tweet to filter keyword
      Queue.put_in({terms, tweet})
    end)
  end
end

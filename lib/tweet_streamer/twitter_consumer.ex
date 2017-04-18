defmodule TweetStreamer.TwitterConsumer do
  use GenStage
  alias TweetStreamer.TwitterFilter

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [TwitterFilter]}
  end

  def handle_events(events, _from, state) do
    [{_terms, tweets}] = events
    tweets |> Enum.each(&print_events/1)
    # As a consumer we never emit events
    {:noreply, [], state}
  end

  def print_events(event) do
    #IO.puts "INSIDE CONSUMER print_events: #{inspect(event)}"
    channel = event.term
    tweet = event.tweet

    {:ok, stored_tweet} = TweetStreamer.RepoHelpers.store_channel_and_tweet(channel, tweet)

    payload = %{
      "username" => stored_tweet.username,
      "text" => stored_tweet.text,
      "id_str" => stored_tweet.id_str,
      "profile_image_url_https" => stored_tweet.profile_image_url_https,
      "image_url" => stored_tweet.image_url,
      "source_url" => stored_tweet.source_url,
      "created_at" => stored_tweet.created_at
    }

    # Broadcast the tweet to WS channel matching term
    # To broacast stored_tweet we need to create a map with only the required fields matching the database record!
    TwitterPlayground.Endpoint.broadcast!("tweets:"<>channel, "tweet", %{tweet: payload})
  end
end

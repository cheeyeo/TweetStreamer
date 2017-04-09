defmodule TweetStreamer.RepoHelpers do
  import Ecto.Query, only: [from: 2]
  alias TwitterPlayground.Channel
  alias TwitterPlayground.Tweet
  alias TwitterPlayground.Repo

  def conditionally_store_channel(term) do
    channel = %Channel{
      name: term
    }

    unless channel_exists?(channel) do
      store_channel(channel)
    end
  end

  def channel_exists?(channel) do
    query = from channel in Channel,
      where: channel.name == ^channel.name,
      select: count(channel.id)

    Repo.one(query) > 0
  end

  def store_channel(%Channel{}=channel) do
    IO.puts "Storing channel: #{inspect(channel)}"
    Repo.insert(channel)
  end

  def conditionally_store_tweet(tweet) do
    channel = %Tweet{
      username: tweet.user.screen_name,
      text: tweet.text,
      id_str: tweet.id_str,
      created_at: tweet.created_at
    }

    unless tweet_exists?(tweet) do
      store_tweet(tweet)
    end
  end

  def tweet_exists?(tweet) do
    query = from tweet in Tweet,
      where: tweet.id_str == ^tweet.id_str,
      select: count(tweet.id)

    Repo.one(query) > 0
  end

  def store_tweet(%Tweet{}=tweet) do
    IO.puts "Storing tweet: #{inspect(tweet)}"
    Repo.insert(tweet)
  end
end

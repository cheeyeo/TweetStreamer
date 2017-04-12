defmodule TweetStreamer.RepoHelpers do
  import Ecto.Query, only: [from: 2]
  alias TwitterPlayground.Channel
  alias TwitterPlayground.Repo
  use Timex

  def cast_timestamp(timestamp) do
    [dow, mon, day, time, zone, year] = String.split(timestamp, " ")
    rfc1123 = Enum.join(["#{dow},", day, mon, year, time, zone], " ")

    rfc1123
    |> Timex.parse!("{RFC1123}")
    |> Ecto.DateTime.cast!()
  end

  def store_channel_and_tweet(channel_name, tweet) do
    Repo.transaction fn ->
      query = from c in Channel,
        where: c.name == ^channel_name

      channel =
        case Repo.one(query) do
          (%Channel{}=channel) -> channel
          nil -> Repo.insert!(%Channel{name: channel_name})
        end

      IO.puts "Found channel: #{inspect(channel)}"

      tweet_attrs = %{
        username: tweet.user.screen_name,
        text: tweet.text,
        id_str: tweet.id_str,
        profile_image_url_https: tweet.user.profile_image_url_https,
        created_at: cast_timestamp(tweet.created_at)
      }

      tweet_attrs = case has_images?(tweet) do
        true ->
          Map.merge(tweet_attrs, %{
            image_url: first_photo(tweet).media_url,
            source_url: first_photo(tweet).expanded_url
          })
        false ->
          tweet_attrs
      end

      tweetz = Ecto.build_assoc(channel, :tweets, tweet_attrs)
      Repo.insert!(tweetz)
    end
  end

  def has_images?(%ExTwitter.Model.Tweet{}=tweet) do
    Map.has_key?(tweet.entities, :media) &&
    Enum.any?(photos(tweet))
  end

  def photos(%ExTwitter.Model.Tweet{}=tweet) do
    tweet.entities.media
    |> Enum.filter(fn(medium) ->
      medium.type == "photo"
    end)
  end

  defp first_photo(%ExTwitter.Model.Tweet{}=tweet) do
    photos(tweet)
    |> hd
  end
end

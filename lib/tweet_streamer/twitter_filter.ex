defmodule TweetStreamer.TwitterFilter do
  use GenStage
  alias TweetStreamer.Queue

  require Logger

  # Public API
  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Server API
  def init(:ok) do
    {:producer_consumer, :ok, subscribe_to: [Queue]}
  end

  def handle_events(events, _from, :ok) do
    Logger.debug("INSIDE HANDLE_EVENTS: #{inspect(events)}")
    events =
      events
      |> Enum.map(&filter_tweets/1)

    {:noreply, events, :ok}
  end

  defp filter_tweets({terms, tweet}) do
    Logger.debug("INSIDE FILTER TWEETS: #{inspect(terms)}")
    Logger.debug("INSIDE FILTER TWEETS: #{inspect(tweet)}")

    {terms, tweet}
  end
end

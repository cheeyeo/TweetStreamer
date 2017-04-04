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
    events =
      events
      |> Enum.map(&filter_tweets/1)

    {:noreply, events, :ok}
  end

  def filter_tweets({terms, tweet}) do
    Enum.map_reduce(terms, [], fn(term, acc) ->
      map = if tweet.text =~ term do
              Map.put_new(%{}, :term, term)
              |> Map.put_new(:tweet, tweet)
            end

      new_acc = case is_nil(map) do
        false ->
          acc ++ [map]
        true ->
          acc
      end

      {term, new_acc}
    end)
  end
end

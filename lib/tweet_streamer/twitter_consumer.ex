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
    IO.puts "INSIDE CONSUMER print_events: #{inspect(event)}"
    channel = event[:term]
    tweet = event[:tweet]
    TwitterPlayground.Endpoint.broadcast!("tweets:"<>channel, "tweet", %{tweet: tweet})
  end
end

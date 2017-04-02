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
    events |> Enum.map(&print_events/1)
    # As a consumer we never emit events
    {:noreply, [], state}
  end

  def print_events(event) do
    IO.inspect "INSIDE CONSUMER: #{inspect(event)}"
  end
end

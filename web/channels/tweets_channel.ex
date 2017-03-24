defmodule TwitterPlayground.TweetsChannel do
  use TwitterPlayground.Web, :channel

  def join("tweets:"<>query, _params, socket) do
    {:ok, _pid} = TwitterPlayground.start_streamer(query)
    {:ok, %{status: "successful"}, socket}
  end

  def handle_in("track", %{"query" => query}, socket) do
    IO.puts "QUERY: #{query}"
    TwitterPlayground.track(counter_id(socket.topic), socket_ref(socket), self())
    {:noreply, socket}
  end

  def handle_info({:tweet_received, tweet, ref}, socket) do
    reply ref, {:ok, %{tweet: tweet}}
    {:noreply, socket}
  end

  defp counter_id(topic_string) do
    topic_string |> String.split(":") |> Enum.drop(1) |> hd
  end
end

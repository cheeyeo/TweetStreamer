defmodule TwitterPlayground.TweetsChannel do
  use TwitterPlayground.Web, :channel

  def join("tweets:"<>query, _params, socket) do
    {:ok, _pid} = TwitterPlayground.start_streamer(query)
    send(self(), :track_query)
    {:ok, %{status: "successful"}, socket}
  end

  # handle_info means its internal call
  def handle_info(:track_query, socket) do
    TwitterPlayground.track(counter_id(socket.topic))
    {:noreply, socket}
  end

  defp counter_id(topic_string) do
    topic_string |> String.split(":") |> Enum.drop(1) |> hd
  end
end

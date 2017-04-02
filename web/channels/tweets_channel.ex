defmodule TwitterPlayground.TweetsChannel do
  use TwitterPlayground.Web, :channel

  def join("tweets:"<>_query, _params, socket) do
    {:ok, %{status: "successful"}, socket}
  end

  def handle_in("track", %{"query" => query}, socket) do
    TwitterPlayground.track(query)
    TwitterPlayground.start_tracker()
    {:noreply, socket}
  end
end

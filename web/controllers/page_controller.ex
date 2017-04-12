defmodule TwitterPlayground.PageController do
  use TwitterPlayground.Web, :controller

  alias TwitterPlayground.{Channel, Tweet}

  def index(conn, _params) do
    tweets_query = from t in Tweet, order_by: t.created_at
    query = from c in Channel,
      order_by: c.name,
      preload: [tweets: ^tweets_query]

    channels = Repo.all(query)
    # we load the first channel, preload its tweets and start the streamer.
    first_channel = channels |> List.first
    render(conn, "index.html", channels: channels, loaded_channel: first_channel)
  end
end

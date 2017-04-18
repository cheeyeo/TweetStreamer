# Plug to render channels on right hand side
defmodule TwitterPlayground.ChannelsNav do
  import Plug.Conn
  import Ecto.Query

  alias TwitterPlayground.Channel

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    query = from c in Channel,
      order_by: c.name
      #select: map(c, [:name, :id])

    channels = repo.all(query)
    assign(conn, :channels_nav, channels)
  end
end

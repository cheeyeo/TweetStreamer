defmodule TwitterPlayground.ChannelController do
  use TwitterPlayground.Web, :controller

  alias TwitterPlayground.{Channel, Tweet}

  def show(conn, %{"id" => id}) do
    tweets_query = from t in Tweet, order_by: t.created_at
    query = from c in Channel,
      preload: [tweets: ^tweets_query],
      where: (c.id == ^id)

    channel = Repo.one(query)

    # starts the tracker if its not started ....
    TwitterPlayground.start_tracker()

    render(conn, "show.html", loaded_channel: channel)
  end

  def index(conn, _params) do
    channels = Repo.all(Channel)
    render(conn, "index.html", channels: channels)
  end

  def new(conn, _params) do
    changeset = Channel.changeset(%Channel{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"channel" => channel_params}) do
    changeset = Channel.changeset(%Channel{}, channel_params)

    case Repo.insert(changeset) do
      {:ok, channel} ->
        TwitterPlayground.stop_tracker()
        TwitterPlayground.start_tracker()

        conn
        |> put_flash(:info, "Channel created successfully.")
        |> redirect(to: channel_path(conn, :show, channel))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    channel = Repo.get!(Channel, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(channel)

    conn
    |> put_flash(:info, "Channel deleted successfully.")
    |> redirect(to: channel_path(conn, :index))
  end
end

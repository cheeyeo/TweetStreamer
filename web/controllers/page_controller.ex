defmodule TwitterPlayground.PageController do
  use TwitterPlayground.Web, :controller

  def index(conn, _params) do
    # grabs the first channel from nav if exists and redirect to it
    # if blank then show notice to create a new channel
    if Enum.any?(conn.assigns[:channels_nav]) do
      loaded_channel = conn.assigns[:channels_nav] |> List.first
      redirect conn, to: channel_path(conn, :show, loaded_channel)
    else
      render(conn, "index.html")
    end
  end
end

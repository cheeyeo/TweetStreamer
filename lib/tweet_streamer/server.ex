defmodule TweetStreamer.Server do
  use GenServer
  require Logger

  # Public API
  def start_link do
    GenServer.start_link(__MODULE__, [], name: :tweetstreamer_server)
  end

  def add(query) do
    Logger.info "QUERY: #{query}"
    GenServer.cast(:tweetstreamer_server, {:add, query})
  end

  def remove(query) do
    GenServer.cast(:tweetstreamer_server, {:remove, query})
  end

  def get_queries do
    GenServer.call(:tweetstreamer_server, {:queries})
  end

  # Create new MapSet
  def clear do
    GenServer.cast(:tweetstreamer_server, {:clear})
  end

  # Server API
  def init(_) do
    {:ok, MapSet.new}
  end

  def handle_cast({:add, query}, state) do
    new_set = MapSet.put(state, query)
    {:noreply, new_set}
  end

  def handle_cast({:remove, query}, state) do
    new_set = MapSet.delete(state, query)
    {:noreply, new_set}
  end

  def handle_cast({:clear}, _state) do
    {:noreply, MapSet.new}
  end

  def handle_call({:queries}, _from, state) do
    list = MapSet.to_list(state)
    {:reply, list, state}
  end
end

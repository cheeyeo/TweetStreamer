defmodule TwitterPlayground.RoomChannel do
  use TwitterPlayground.Web, :channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("work", %{"body" => body}, socket) do
    worker = spawn(fn() -> TwitterPlayground.Worker.greet end)
    # send to external worker process
    send worker, {self(), body, socket_ref(socket)}
    {:noreply, socket}
  end

  def handle_info({:work_complete, result, ref}, socket) do
    reply ref, {:ok, %{body: result}}
    {:noreply, socket}
  end
end

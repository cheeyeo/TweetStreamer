defmodule TweetStreamer.ServerTest do
  use ExUnit.Case, async: true

  alias TweetStreamer.Server

  setup do
    Server.clear()
  end

  test "server already started on startup" do
    {:error, {:already_started, _pid}} = Server.start_link()
  end

  test "adding a query" do
    :ok = Server.add("one")
    assert ["one"] = Server.get_queries()
  end

  test "removing a query" do
    :ok = Server.add("two")
    :ok = Server.add("one")

    :ok = Server.remove("two")
    assert ["one"] = Server.get_queries()

    Server.remove("one")
    assert [] = Server.get_queries()

    Server.remove("one")
    assert [] = Server.get_queries()
  end

  test "ignore duplicates" do
    :ok = Server.add("foo")
    :ok = Server.add("foo")
    :ok = Server.add("baz")
    :ok = Server.add("bar")
    assert ["bar", "baz", "foo"] = Server.get_queries()
  end

  test "returns terms in sorted order" do
    :ok = Server.add("3")
    :ok = Server.add("2")
    :ok = Server.add("1")
    assert ["1", "2", "3"] = Server.get_queries()
  end
end

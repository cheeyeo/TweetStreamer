defmodule TweetStreamer.TwitterFilterTest do
  use ExUnit.Case

  alias TweetStreamer.TwitterFilter

  describe "working" do
    test "map terms to tweets" do
      terms = ["apple", "pears"]
      tweet = %ExTwitter.Model.Tweet{text: "This tweet contains an apple"}

      events = [{terms, tweet}]
      {:noreply, [{_, result}], :ok} = TwitterFilter.handle_events(events, self(), :ok)

      assert [%{term: "apple", tweet: tweet}] == result
    end

    test "map multiple matching terms to multiple tweets" do
      terms = ["apple", "pears"]
      tweet = %ExTwitter.Model.Tweet{text: "This tweet contains an apple and pears"}

      events = [{terms, tweet}]
      {:noreply, [{_, result}], :ok} = TwitterFilter.handle_events(events, self(), :ok)
      assert [%{term: "pears", tweet: tweet}, %{term: "apple", tweet: tweet}] == result
    end

    test "map multiple interleaving matching terms to multiple tweets" do
      terms = ["apple", "no match", "apple"]
      tweet = %ExTwitter.Model.Tweet{text: "This tweet contains an apple"}

      events = [{terms, tweet}]
      {:noreply, [{_, result}], :ok} = TwitterFilter.handle_events(events, self(), :ok)
      assert [%{term: "apple", tweet: tweet}, %{term: "apple", tweet: tweet}] == result
    end

    test "returns empty list with no matches" do
      terms = ["no matches"]
      tweet = %ExTwitter.Model.Tweet{text: "This tweet contains an apple"}

      events = [{terms, tweet}]
      {:noreply, [{_, result}], :ok} = TwitterFilter.handle_events(events, self(), :ok)
      assert [] == result
    end
  end
end

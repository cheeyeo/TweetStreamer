defmodule TwitterPlayground.TweetTest do
  use TwitterPlayground.ModelCase

  alias TwitterPlayground.Tweet

  @valid_attrs %{created_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, id_str: "some content", text: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tweet.changeset(%Tweet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tweet.changeset(%Tweet{}, @invalid_attrs)
    refute changeset.valid?
  end
end

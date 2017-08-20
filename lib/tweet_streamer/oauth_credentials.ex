defmodule TweetStreamer.OauthCredentials do
  @creds Application.get_env(:twitter_playground, :oauth)

  def start_link(name) do
    Agent.start_link(fn -> 0 end, name: name)
  end

  def update_state(num) do
    update = if(num < 1, do: 1, else: 0)
    Agent.update(Numbers, fn(_state) -> update end)
  end

  def current_state() do
    Agent.get(Numbers, &(&1))
  end

  # Load random creds from list above
  def creds() do
    num = current_state()
    update_state(num)
    Enum.at(@creds, num)
  end
end

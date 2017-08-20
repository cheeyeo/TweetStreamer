defmodule TweetStreamer.OauthCredentials do
  @creds Application.get_env(:twitter_playground, :oauth)
  @agent Application.get_env(:twitter_playground, :agent_name)

  def start_link(_name) do
    Agent.start_link(fn -> 0 end, name: @agent)
  end

  def update_state(num) do
    new_state = if(num < 1, do: 1, else: 0)
    Agent.update(@agent, fn(_state) -> new_state end)
  end

  def current_state() do
    Agent.get(@agent, &(&1))
  end

  # Load random creds from list above
  def creds() do
    num = current_state()
    update_state(num)
    Enum.at(@creds, num)
  end
end

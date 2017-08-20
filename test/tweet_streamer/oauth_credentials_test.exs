defmodule TweetStreamer.OauthCredentialsTest do
  use ExUnit.Case

  alias TweetStreamer.OauthCredentials

  test "agent started by supervisor on load" do
    {:error, {status, _pid}} = OauthCredentials.start_link(Numbers)
    assert status == :already_started
  end

  test "alternate state to 0 when given 1" do
    OauthCredentials.update_state(1)
    assert 0 == OauthCredentials.current_state()
  end

  test "alternate state to 1 when given 0" do
    OauthCredentials.update_state(0)
    assert 1 == OauthCredentials.current_state()
  end

  test "load alternate second set of secrets if the state is 0" do
    OauthCredentials.update_state(0)

    assert [consumer_key: 'test_key_2',
    consumer_secret: 'test_secret_2',
    access_token: 'test_token_2',
    access_token_secret: 'test_token_secret_2'] == OauthCredentials.creds()
  end

  test "load alternate first set of secrets if the state is 1" do
    OauthCredentials.update_state(1)

    assert [consumer_key: 'test_key_1',
    consumer_secret: 'test_secret_1',
    access_token: 'test_token_1',
    access_token_secret: 'test_token_secret_1'] == OauthCredentials.creds()
  end
end

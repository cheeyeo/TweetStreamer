# TwitterPlayground

Streaming twitter feeds into a web page via channels.

Its still very much WIP and rough at the edges


# Start

You need to register for a twitter development account and register an application to obtain the creds.

Then create a .env file with the following keys:

```
export TWITTER_CONSUMER_KEY=<your key>
export TWITTER_CONSUMER_SECRET=<your secret>
export TWITTER_ACCESS_TOKEN=<your token>
export TWITTER_ACCESS_SECRET=<your secret>
```

Then source the env variables:
```
source .env
```
Then run

```
mix phoenix.server
```

Visit the page at http://localhost:4000


# Notes on extwitter

To stop the streaming after 5 seconds:

```
pid = spawn(fn ->
  stream = ExTwitter.stream_filter(track: "apple")
  for tweet <- stream do
    IO.puts tweet.text
  end
end)

:timer.sleep(5000)
ExTwitter.stream_control(pid, :stop)

```


# Todo

* Process registry

https://m.alphasights.com/process-registry-in-elixir-a-practical-example-4500ee7c0dcc#.rlfgbft4w

( can kill the process using the gproc or registry directly ....)


* Do we need to add supervisor to the tweet streamer process ...?

( refer to blog above )


* Store tweets into database

  Need to create separate worker task

* Run the spawned extwitter stream in intervals

http://minhajuddin.com/2016/10/27/a-simple-ticker-to-receive-tick-events-for-every-interval-in-elixir/

http://stackoverflow.com/questions/32085258/how-to-run-some-code-every-few-hours-in-phoenix-framework

( check out the GenServer example )


* How do we use Phoenix.Channel.reply/2 for async reply to channel push

http://stackoverflow.com/questions/37391528/how-to-use-phoenix-channel-reply-2-for-async-reply-to-channel-push

https://github.com/phoenixframework/phoenix/blob/master/lib/phoenix/channel.ex

https://github.com/BlackrockDigital/startbootstrap-simple-sidebar


https://getbootstrap.com/examples/dashboard/

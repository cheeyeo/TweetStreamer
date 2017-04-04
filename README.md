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

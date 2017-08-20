use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :twitter_playground, TwitterPlayground.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :twitter_playground, TwitterPlayground.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "twitter_playground_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :twitter_playground, :oauth, [
  %{consumer_key: 'test_key_1',
    consumer_secret: 'test_secret_1',
    access_token: 'test_token_1',
    access_token_secret: 'test_token_secret_1'},
  %{consumer_key: 'test_key_2',
    consumer_secret: 'test_secret_2',
    access_token: 'test_token_2',
    access_token_secret: 'test_token_secret_2'}
]

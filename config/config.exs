# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :twitter_playground,
  ecto_repos: [TwitterPlayground.Repo]

# Configures the endpoint
config :twitter_playground, TwitterPlayground.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7a2mDu+5dfO4Fd1/MeWpmM6o9sPGwzmSmEuAjJiT5YjooQkHYDb9wM/q8MCaFpdy",
  render_errors: [view: TwitterPlayground.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TwitterPlayground.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :twitter_playground, :agent_name, CredentialId

config :twitter_playground, :oauth, [
  [
    consumer_key: System.get_env("TWITTER_CONSUMER_KEY_1"),
    consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET_1"),
    access_token: System.get_env("TWITTER_ACCESS_TOKEN_1"),
    access_token_secret: System.get_env("TWITTER_ACCESS_SECRET_1")
  ],
  [
    consumer_key: System.get_env("TWITTER_CONSUMER_KEY_2"),
    consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET_2"),
    access_token: System.get_env("TWITTER_ACCESS_TOKEN_2"),
    access_token_secret: System.get_env("TWITTER_ACCESS_SECRET_2")
  ]
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

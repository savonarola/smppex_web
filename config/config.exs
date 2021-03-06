# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# Configures the endpoint
config :smppex_web, SmppexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0v9JxtkmEQXmaB6/1eOwQWgC3ZOAm+WEs7TTnSLemi1yJbKB7KXuq3J/DqWk6ISO",
  render_errors: [view: SmppexWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: SmppexWeb.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

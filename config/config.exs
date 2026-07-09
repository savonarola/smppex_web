import Config

config :smppex_web,
  ecto_repos: []

config :smppex_web, SmppexWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SmppexWeb.ErrorHTML, json: SmppexWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SmppexWeb.PubSub,
  live_view: [signing_salt: "NYRxPr7X"],
  secret_key_base: "0v9JxtkmEQXmaB6/1eOwQWgC3ZOAm+WEs7TTnSLemi1yJbKB7KXuq3J/DqWk6ISO"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"

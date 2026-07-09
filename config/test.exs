import Config

config :smppex_web, SmppexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4001],
  secret_key_base: "0v9JxtkmEQXmaB6/1eOwQWgC3ZOAm+WEs7TTnSLemi1yJbKB7KXuq3J/DqWk6ISO",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime

config :smppex_web, SmppexWeb.MC,
  port: 2776,
  max_connections: 30

import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :smppex_web, SmppexWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :smppex_web, SmppexWeb.MC,
  port: 2776,
  max_connections: 30

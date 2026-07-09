import Config

config :smppex_web, SmppexWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :smppex_web, SmppexWeb.MC,
  port: 2775,
  max_connections: 30

use Mix.Config

config :smppex_web, SmppexWeb.Endpoint,
  http: [port: 8080],
  url: [host: "smppex.rubybox.ru", port: 80],
  cache_static_manifest: "priv/static/manifest.json"

config :logger, level: :info

import_config "prod.secret.exs"

config :logger, :console, format: "[$level] $message\n"

config :smppex_web, SmppexWeb.MC,
  port: 2775,
  max_connections: 30

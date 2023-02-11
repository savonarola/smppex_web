import Config

config :smppex_web, SmppexWeb.Endpoint,
  http: [port: 8080],
  code_reloader: false,
  server: true,
  url: [host: "smppex.rubybox.dev", scheme: "https", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: [
    "https://smppex.rubybox.dev",
    "http://localhost:8080",
    "http://127.0.0.1:8080"
  ]

config :logger, level: :info

config :smppex_web, SmppexWeb.MC,
  port: 2775,
  max_connections: 30

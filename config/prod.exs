use Mix.Config


config :smppex_web, SmppexWeb.Endpoint,
  http: [port: 8080],
  url: [host: "smppex.rubybox.ru", port: 80],
  cache_static_manifest: "priv/static/manifest.json"

config :logger, level: :info

import_config "prod.secret.exs"

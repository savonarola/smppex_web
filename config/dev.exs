import Config

config :smppex_web, SmppexWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "0v9JxtkmEQXmaB6/1eOwQWgC3ZOAm+WEs7TTnSLemi1yJbKB7KXuq3J/DqWk6ISO",
  watchers: [
    npm: ["run", "watch:js", cd: Path.expand("../assets", __DIR__)],
    npm: ["run", "watch:css", cd: Path.expand("../assets", __DIR__)]
  ],
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg|ico)$},
      ~r{lib/smppex_web/components/.*(ex|heex)$},
      ~r{lib/smppex_web/controllers/.*(ex|heex)$},
      ~r{lib/smppex_web/channels/.*(ex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime

config :smppex_web, SmppexWeb.MC,
  port: 2775,
  max_connections: 30

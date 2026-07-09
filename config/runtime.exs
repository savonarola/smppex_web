import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "smppex.rubybox.dev"
  port = String.to_integer(System.get_env("PORT") || "8080")

  config :smppex_web, SmppexWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: port],
    secret_key_base: secret_key_base,
    server: true,
    check_origin: ["https://#{host}", "http://localhost:8080", "http://127.0.0.1:8080"]
end

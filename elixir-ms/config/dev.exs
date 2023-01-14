import Config

config :elixir_ms, timezone: "America/Bogota"

config :elixir_ms,
       http_port: 8080,
       enable_server: true,
       secret_name: "",
       region: "",
       version: "0.0.1",
       in_test: false,
       custom_metrics_prefix_name: "elixir_ms_local"

config :logger,
       level: :debug

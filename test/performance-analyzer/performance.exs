import Config

config :perf_analyzer,
  url: "http://_IP_:8080/api/_SCENARIO_",
  request: %{
    method: "GET",
    headers: [],
    body: ""
  },
  execution: %{
    steps: 30,
    increment: 100,
    duration: 2000,
    constant_load: false,
    dataset: :none,
    separator: ","
  },
  distributed: :none

config :logger,
  level: :warn

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_monitoring_prom,
  ecto_repos: [ElixirMonitoringProm.Repo]

# Configures the endpoint
config :elixir_monitoring_prom, ElixirMonitoringPromWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nFSyXdlKCXuXTXWhnmEeVnA9VLzzbpuqX3UvpdaPo8uqpgjxd+cZorH+0GobASx8",
  render_errors: [view: ElixirMonitoringPromWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ElixirMonitoringProm.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [ElixirMonitoringProm.PhoenixInstrumenter]

config :prometheus, ElixirMonitoringProm.PipelineInstrumenter,
  labels: [:status_class, :method, :host, :scheme, :request_path],
  duration_buckets: [
    10,
    100,
    1_000,
    10_000,
    100_000,
    300_000,
    500_000,
    750_000,
    1_000_000,
    1_500_000,
    2_000_000,
    3_000_000
  ],
  registry: :default,
  duration_unit: :microseconds

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

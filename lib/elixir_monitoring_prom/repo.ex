defmodule ElixirMonitoringProm.Repo do
  use Ecto.Repo,
    otp_app: :elixir_monitoring_prom,
    adapter: Ecto.Adapters.Postgres
end

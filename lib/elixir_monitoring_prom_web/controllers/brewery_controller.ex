defmodule ElixirMonitoringPromWeb.BreweryController do
  use ElixirMonitoringPromWeb, :controller

  alias ElixirMonitoringProm.{Breweries, Metrics}

  def index(conn, %{"zip_code" => zip_code, "mile_radius" => radius}) do
    results = Breweries.get_breweries_in_radius(zip_code, String.to_integer(radius))
    Metrics.increment_zip_code_search(zip_code)
    Metrics.observe_radius_search(radius)

    json(conn, results)
  end

  def index(conn, _) do
    conn
    |> json(%{
      error: "\"zip_code\" and \"mile_radius\" are both required fields"
    })
  end
end

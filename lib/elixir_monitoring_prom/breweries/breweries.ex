defmodule ElixirMonitoringProm.Breweries do
  alias ElixirMonitoringProm.{Breweries.Brewery, Repo, ZipCodes}
  import Ecto.Query

  def get_breweries_in_radius(zip_code_to_search, radius_in_miles) do
    zip_codes_in_radius =
      zip_code_to_search
      |> ZipCodes.get_zip_codes_in_radius(radius_in_miles)
      |> case do
        {:ok, zip_codes} -> Enum.map(zip_codes, & &1.zip_code)
        error -> error
      end

    query =
      from brewery in Brewery,
        where: brewery.zip_code in ^zip_codes_in_radius

    Repo.all(query)
  end
end

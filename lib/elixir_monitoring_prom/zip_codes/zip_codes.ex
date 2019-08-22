defmodule ElixirMonitoringProm.ZipCodes do
  alias ElixirMonitoringProm.{Repo, ZipCodes.ZipCode}

  import Ecto.Query

  def get_zip_codes_in_radius(zip_code, radius_in_miles) do
    # Our raw Postgres query to get all the zip codes within a radius
    query =
      [
        "WITH target AS (SELECT point AS p FROM zip_codes WHERE zip_code = $1::varchar)",
        "SELECT id, zip_code, city, state, timezone, dst, point FROM zip_codes JOIN target ON true",
        "WHERE ST_DWithin(p::geography, zip_codes.point::geography, $2::double precision)"
      ]
      |> Enum.join(" ")

    # The arguments we are passing to the query
    args = [zip_code, miles_to_meters(radius_in_miles)]

    # Since we used a raw SQL query, we'll need to manually (for more information
    # see https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.html#query/4)
    case Repo.query(query, args, log: true) do
      {:ok, %Postgrex.Result{columns: cols, rows: rows}} ->
        results =
          Enum.map(rows, fn row ->
            Repo.load(ZipCode, {cols, row})
          end)

        {:ok, results}

      _ ->
        {:error, :not_found}
    end
  end

  def get_zip_code_info(zip) do
    Repo.one(from zip_code in ZipCode, where: zip_code.zip_code == ^zip)
  end

  defp miles_to_meters(miles), do: miles * 1609.344
end

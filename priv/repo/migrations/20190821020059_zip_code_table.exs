defmodule ElixirMonitoringProm.Repo.Migrations.ZipCodeTable do
  use Ecto.Migration

  alias ElixirMonitoringProm.ZipCodes.ZipCode

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS postgis")

    create table(:zip_codes) do
      add :zip_code, :string, size: 5, null: false
      add :city, :string, null: false
      add :state, :string, size: 2, null: false
      add :timezone, :integer, null: false
      add :dst, :boolean, null: false
    end

    execute("SELECT AddGeometryColumn('zip_codes', 'point', 4326, 'POINT', 2)")
    execute("CREATE INDEX zip_code_point_index on zip_codes USING gist (point)")

    create unique_index(:zip_codes, [:zip_code])

    flush()

    "#{__DIR__}/../wa_zip_codes.csv"
    |> File.read!()
    |> String.split("\n")
    |> Enum.filter(fn line -> String.trim(line) != "" end)
    |> Enum.map(fn csv_line ->
      [zip, city, state, lat, long, tz, dst] =
        csv_line
        |> String.replace("\"", "")
        |> String.replace("\n", "")
        |> String.split(",")

      city = String.downcase(city)
      state = String.downcase(state)

      attrs = %{
        zip_code: zip,
        city: city,
        state: state,
        point: %Geo.Point{coordinates: {long, lat}, srid: 4326},
        timezone: String.to_integer(tz),
        dst: (dst == "1" && true) || false
      }

      ZipCode.changeset(%ZipCode{}, attrs)
    end)
    |> Enum.each(fn zip_code_changeset ->
      ElixirMonitoringProm.Repo.insert(zip_code_changeset, on_conflict: :nothing)
    end)
  end

  def down do
    drop(table(:zip_codes))
    execute("DROP EXTENSION IF EXISTS postgis")
  end
end

defmodule ElixirMonitoringProm.Repo.Migrations.BreweryTable do
  use Ecto.Migration

  alias ElixirMonitoringProm.{Breweries.Brewery, Repo, ZipCodes.ZipCode}
  alias Faker.{Beer, Company}

  import Ecto.Query

  def up do
    create table(:breweries) do
      add :brand, :string
      add :beers, {:array, :string}
      add :zip_code, :string
    end

    create index(:breweries, [:zip_code])

    # Flush the database changes so that we can populate the tables with dummy data
    flush()

    Faker.start()

    # Go through all of the zip codes in WA state and create between 1-3 brewers
    ZipCode
    |> Repo.all()
    |> Enum.each(fn %ZipCode{zip_code: zip_code} ->
      num_breweries = Enum.random(1..3)
      generate_breweries(zip_code, num_breweries)
    end)
  end

  defp generate_breweries(_zip_code, 0), do: :ok

  defp generate_breweries(zip_code, count) do
    attrs = %{
      brand: Company.name() <> " Brewers",
      beers: [Beer.name(), Beer.name()],
      zip_code: zip_code
    }

    %Brewery{}
    |> Brewery.changeset(attrs)
    |> Repo.insert()

    generate_breweries(zip_code, count - 1)
  end

  def down do
    drop table(:breweries)
  end
end

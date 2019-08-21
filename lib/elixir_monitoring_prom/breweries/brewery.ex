defmodule ElixirMonitoringProm.Breweries.Brewery do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @derive {Jason.Encoder, only: ~w(brand beers zip_code)a}
  schema "breweries" do
    field :brand, :string
    field :beers, {:array, :string}
    field :zip_code, :string
  end

  def changeset(%Brewery{} = brewery, attrs \\ %{}) do
    all_fields = [:brand, :beers, :zip_code]

    brewery
    |> cast(attrs, all_fields)
    |> validate_required(all_fields)
  end
end


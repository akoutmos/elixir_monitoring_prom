defmodule ElixirMonitoringProm.ZipCodes.ZipCode do
  @moduledoc """
  Schema to define zip code entries
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  schema "zip_codes" do
    field :zip_code, :string
    field :city, :string
    field :state, :string
    field :point, Geo.PostGIS.Geometry
    field :timezone, :integer
    field :dst, :boolean
  end

  def changeset(%ZipCode{} = zip_code, attrs \\ %{}) do
    all_fields = [:zip_code, :city, :state, :point, :timezone, :dst]

    zip_code
    |> cast(attrs, all_fields)
    |> validate_required(all_fields)
  end
end

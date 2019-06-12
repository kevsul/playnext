defmodule Playnext.Platform do
  use Ecto.Schema
  import Ecto.Changeset

  schema "platforms" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(platform, attrs) do
    platform
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

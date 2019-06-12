defmodule Playnext.Genre do
  use Ecto.Schema
  import Ecto.Changeset

  schema "genres" do
    field :name, :string

    many_to_many :games, Playnext.Game, join_through: "games_genres"

    timestamps()
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def get(name) do
    found = Playnext.Repo.get_by(Playnext.Genre, name: name)

    if found do
      found
    else
      Playnext.Repo.insert!(%Playnext.Genre{name: name})
    end
  end
end

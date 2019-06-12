defmodule Playnext.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :name, :string
    field :description, :string
    field :image, :string
    field :release_date, :date
    field :steam_appid, :integer
    field :store, :string
    field :store_id, :integer

    many_to_many :tags, Playnext.Tag, join_through: "games_tags"
    many_to_many :genres, Playnext.Genre, join_through: "games_genres"
    many_to_many :platforms, Playnext.Platform, join_through: "games_platforms"

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def get(name) do
    Playnext.Repo.get_by(Playnext.Game, name: name)
  end

  def add_genre(game_name, genre_name) do
    IO.puts("Adding genre " <> genre_name <> " to game " <> game_name)
    game = Playnext.Game.get(game_name)
    genre = Playnext.Genre.get(genre_name)

    game = Playnext.Repo.preload(game, :genres)

    genres =
      (game.genres ++ [genre])
      |> Enum.map(&Ecto.Changeset.change/1)

    game
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:genres, genres)
    |> Playnext.Repo.update()
  end
end

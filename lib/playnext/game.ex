require Logger
alias Playnext.Repo
alias Playnext.Tag
alias Playnext.Genre
alias Playnext.Platform

defmodule Playnext.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field(:name, :string)
    field(:description, :string)
    field(:image, :string)
    field(:release_date, :date)
    field(:steam_appid, :integer)
    field(:store, :string)
    field(:store_id, :integer)

    many_to_many(:tags, Tag, join_through: "games_tags")
    many_to_many(:genres, Genre, join_through: "games_genres")
    many_to_many(:platforms, Platform, join_through: "games_platforms")

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def get(name) do
    Repo.get_by(__MODULE__, name: name)
  end

  def add_tag(game_name, tag_name) do
    Logger.debug("Adding tag #{tag_name} to game #{game_name}")
    game = Repo.preload(get(game_name), :tags)

    if !Enum.any?(game.tags, &(&1.name == tag_name)) do
      tag = Tag.get_or_insert(tag_name)
      tags = Enum.map(game.tags ++ [tag], &Ecto.Changeset.change/1)

      game
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:tags, tags)
      |> Repo.update()
    end
  end

  def add_genre(game_name, genre_name) do
    Logger.debug("Adding genre #{genre_name} to game #{game_name}")
    game = Repo.preload(get(game_name), :genres)

    if !Enum.any?(game.genres, &(&1.name == genre_name)) do
      genre = Genre.get_or_insert(genre_name)
      genres = Enum.map(game.genres ++ [genre], &Ecto.Changeset.change/1)

      game
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:genres, genres)
      |> Repo.update()
    end
  end

  def add_platform(game_name, platform_name) do
    Logger.debug("Adding platform #{platform_name} to game #{game_name}")
    game = Repo.preload(get(game_name), :platforms)

    if !Enum.any?(game.platforms, &(&1.name == platform_name)) do
      platform = Platform.get_or_insert(platform_name)
      platforms = Enum.map(game.platforms ++ [platform], &Ecto.Changeset.change/1)

      game
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:platforms, platforms)
      |> Repo.update()
    end
  end
end

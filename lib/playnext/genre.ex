alias Playnext.Repo
alias Playnext.Game

defmodule Playnext.Genre do
  use Ecto.Schema
  import Ecto.Changeset

  schema "genres" do
    field(:name, :string)

    many_to_many(:games, Game, join_through: "games_genres")

    timestamps()
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc false
  def get(name) do
    Repo.get_by(__MODULE__, name: name)
  end

  @doc false
  def insert(name) do
    Repo.insert!(%__MODULE__{name: name})
  end

  @doc false
  def get_or_insert(name) do
    found = get(name)
    if found, do: found, else: insert(name)
  end
end

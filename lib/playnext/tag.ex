alias Playnext.Repo
alias Playnext.Game

defmodule Playnext.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field(:name, :string)

    many_to_many(:games, Game, join_through: "games_tags")

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def get(name) do
    Repo.get_by(__MODULE__, name: name)
  end

  def insert(name) do
    Repo.insert!(%__MODULE__{name: name})
  end

  def get_or_insert(name) do
    found = get(name)
    if found, do: found, else: insert(name)
  end
end

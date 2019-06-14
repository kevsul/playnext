require Logger
alias Playnext.Repo
alias Playnext.Game

defmodule Playnext.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field(:name, :string)

    field(:items, {:array, :integer})

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc false
  def create(name) do
    Repo.insert!(%__MODULE__{name: name})
  end

  @doc false
  def add_game(list_name, game_id) do
    list = Repo.get_by(__MODULE__, name: list_name)
    game = Repo.get_by(Game, id: game_id)
    if game do
      # if !Enum.any?(list.items, &(&1 == game_id)) do
      if game_id not in list.items do
        Logger.info("Adding #{game.name} to list #{list_name}")
        list
        |> Ecto.Changeset.change(%{items: list.items ++ [game_id]})
        |> Repo.update()
      end
    end
  end
end

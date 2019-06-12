defmodule Playnext.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def get(name) do
    found = Playnext.Repo.get_by(Playnext.Tag, name: name)

    if found do
      found
    else
      tag_db = %Playnext.Tag{name: name}
      Playnext.Repo.insert(tag_db)
    end
  end
end
